import 'package:bid/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:uuid/uuid.dart';

final orderServiceProvider = riverpod.Provider<OrderService>((ref) {
  return OrderService(Supabase.instance.client);
});

class OrderService {
  final SupabaseClient _supabase;

  OrderService(this._supabase);

  // Generate a valid UUID
  String _generateUuid() {
    return const Uuid().v4();
  }

  // Create order from checkout
  Future<Map<String, dynamic>> createOrderFromCheckout({
    required String userId,
    required List<dynamic> products,
    required dynamic shippingAddress,
    required double subtotal,
    required double tax,
    required double shipping,
    required double total,
    required String paymentMethod,
    String? paymentIntentId,
    bool isGuestCheckout = false,
  }) async {
    try {
      print('Creating order with parameters:');
      print('- userId: $userId'); // This could be either auth_id or user_id depending on caller
      print('- isGuestCheckout: $isGuestCheckout');
      print('- products count: ${products.length}');
      print('- total: $total');

      // Step 1: Handle user and address
      final userResult = await _handleUserAndAddress(
        userId: userId,
        shippingAddress: shippingAddress,
        isGuestCheckout: isGuestCheckout,
      );

      // Step 2: Create order record
      final orderId = await _createOrderRecord(
        userIdForDb: userResult['userIdForDb'],
        shippingAddressId: userResult['shippingAddressId'],
        subtotal: subtotal,
        tax: tax,
        shipping: shipping,
        total: total,
      );

      // Step 3: Create payment record
      await _createPaymentRecord(orderId, total);

      // Step 4: Create order items
      await _createOrderItems(orderId, products);

      return {
        'success': true,
        'order_id': orderId,
        'message': 'Order created successfully'
      };
    } catch (e) {
      print('Error creating order: $e');
      return {
        'success': false,
        'message': 'Failed to create order: $e'
      };
    }
  }

  // Handle user and address creation/lookup
  Future<Map<String, dynamic>> _handleUserAndAddress({
    required String userId,
    required dynamic shippingAddress,
    required bool isGuestCheckout,
  }) async {
    String userIdForDb;
    String? shippingAddressId;

    if (isGuestCheckout) {
      final guestResult = await _createGuestUser(shippingAddress);
      userIdForDb = guestResult['userIdForDb'];
      shippingAddressId = guestResult['shippingAddressId'];
    } else {
      // CRITICAL FIX: Determine if userId is an auth_id or user_id
      final isAuthId = await _isAuthId(userId);

      if (isAuthId) {
        print('Provided ID is an auth_id, handling registered user by auth_id');
        final registeredResult = await _handleRegisteredUserByAuthId(userId, shippingAddress);
        userIdForDb = registeredResult['userIdForDb'];
        shippingAddressId = registeredResult['shippingAddressId'];
      } else {
        print('Provided ID is a user_id, using directly');
        // If it's already a user_id, we can use it directly
        userIdForDb = userId;

        // Create shipping address if needed
        if (shippingAddress != null) {
          try {
            // Get email for shipping address
            final userRecord = await _supabase
                .from('users')
                .select('email')
                .eq('user_id', userId)
                .single();

            final userEmail = userRecord['email'];

            shippingAddressId = await _createShippingAddress(
                userIdForDb,
                shippingAddress,
                userEmail
            );
          } catch (e) {
            print('Error creating shipping address: $e');
            // Continue without address if it fails
          }
        }
      }
    }

    return {
      'userIdForDb': userIdForDb,
      'shippingAddressId': shippingAddressId,
    };
  }

  // Helper method to determine if an ID is an auth_id
  Future<bool> _isAuthId(String id) async {
    // First check if this ID exists in the auth system
    final session = _supabase.auth.currentSession;
    if (session != null && session.user.id == id) {
      return true; // It's definitely an auth_id
    }

    // Then check if it exists as an auth_id in our users table
    final authIdCheck = await _supabase
        .from('users')
        .select('user_id')
        .eq('auth_id', id)
        .maybeSingle();

    if (authIdCheck != null) {
      return true; // It exists as an auth_id in our users table
    }

    // Finally check if it exists as a user_id in our users table
    final userIdCheck = await _supabase
        .from('users')
        .select('user_id')
        .eq('user_id', id)
        .maybeSingle();

    if (userIdCheck != null) {
      return false; // It exists as a user_id, so it's not an auth_id
    }

    // If we can't determine for sure, assume it's an auth_id (default behavior)
    return true;
  }

  // Create guest user
  Future<Map<String, dynamic>> _createGuestUser(dynamic shippingAddress) async {
    try {
      print('Creating guest user record...');

      // Generate a random email for the guest user if not provided
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomSuffix = _generateUuid().substring(0, 8); // Take first 8 chars of UUID
      final guestEmail = shippingAddress.email ?? 'guest_${timestamp}_${randomSuffix}@example.com';

      // Generate a pure UUID for the auth_id (no prefix)
      final guestAuthId = _generateUuid();

      // Create a proper UUID for the user_id
      final guestUserId = _generateUuid();

      // Use firstName and lastName instead of name
      final firstName = shippingAddress.firstName ?? '';
      final lastName = shippingAddress.lastName ?? '';

      final guestUserResponse = await _supabase
          .from('users')
          .insert({
        'user_id': guestUserId,
        'email': guestEmail,
        'auth_id': guestAuthId, // Pure UUID format
        'user_type': 'guest',
        'first_name': firstName,
        'last_name': lastName,
        'phone': shippingAddress.phone ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'is_registered': false, // Make sure this is set to false for guests
      })
          .select('user_id')
          .single();

      final userIdForDb = guestUserResponse['user_id'];
      print('Created guest user with ID: $userIdForDb');

      // Create shipping address record
      String? shippingAddressId;
      try {
        shippingAddressId = await _createShippingAddress(userIdForDb, shippingAddress, guestEmail);
      } catch (e) {
        print('Error creating shipping address: $e');
        // Continue without address if it fails
      }

      return {
        'userIdForDb': userIdForDb,
        'shippingAddressId': shippingAddressId,
      };
    } catch (e) {
      print('Error creating guest user: $e');
      throw Exception('Failed to create guest user: $e');
    }
  }

  // Renamed method to clarify it's for auth_id lookup
  Future<Map<String, dynamic>> _handleRegisteredUserByAuthId(String authId, dynamic shippingAddress) async {
    try {
      print('Looking up registered user for auth_id: $authId');

      // Get the current authenticated user's email
      final session = _supabase.auth.currentSession;
      String? authEmail;

      if (session != null && session.user.id == authId) {
        authEmail = session.user.email;
        print('Found authenticated user email: $authEmail');
      }

      String userIdForDb;
      String? shippingAddressId;

      // CRITICAL: First try to find user by email - this is the most reliable way
      var userQuery = [];
      if (authEmail != null) {
        print('Looking up user by email first: $authEmail');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email, auth_id')
            .eq('email', authEmail);

        if (userQuery.isNotEmpty) {
          print('Found user by email: ${userQuery[0]['user_id']} with email: ${userQuery[0]['email']}');

          // If found by email but auth_id doesn't match, update the auth_id
          if (userQuery[0]['auth_id'] != authId) {
            print('Updating auth_id from ${userQuery[0]['auth_id']} to $authId');
            await _supabase
                .from('users')
                .update({'auth_id': authId})
                .eq('user_id', userQuery[0]['user_id']);
            print('Updated auth_id for user found by email');
          }
        }
      }

      // If not found by email, try by auth_id
      if (userQuery.isEmpty) {
        print('User not found by email, trying by auth_id: $authId');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email')
            .eq('auth_id', authId);
      }

      // If user doesn't exist in our users table, we should NOT create one during checkout
      // This is a critical error - the user should be registered or logged in before checkout
      if (userQuery.isEmpty) {
        throw Exception('User not found in database. Please register or log in before checkout.');
      }

      // User exists, get their ID
      userIdForDb = userQuery[0]['user_id'];
      print('Found existing user_id: $userIdForDb with email: ${userQuery[0]['email']}');

      // Update auth_id if it doesn't match and ensure email is correct
      if (authEmail != null && userQuery[0]['email'] != authEmail) {
        await _supabase
            .from('users')
            .update({
          'auth_id': authId,
          'email': authEmail, // Ensure email is always up to date
        })
            .eq('user_id', userIdForDb);
        print('Updated auth_id and email for user: $userIdForDb');
      }

      // Get or create shipping address for registered user
      if (shippingAddress != null) {
        try {
          // Always use the authenticated email for shipping address if available
          final emailForShipping = authEmail ??
              (userQuery.isNotEmpty ? userQuery[0]['email'] : null) ??
              shippingAddress.email;

          shippingAddressId = await _createShippingAddress(
              userIdForDb,
              shippingAddress,
              emailForShipping
          );
        } catch (e) {
          print('Error creating shipping address: $e');
          // Continue without address if it fails
        }
      }

      return {
        'userIdForDb': userIdForDb,
        'shippingAddressId': shippingAddressId,
      };
    } catch (e) {
      print('Error handling registered user: $e');
      throw Exception('Error handling registered user: $e');
    }
  }

  // Create shipping address
  Future<String> _createShippingAddress(String userIdForDb, dynamic shippingAddress, String? fallbackEmail) async {
    print('Creating shipping address record...');
    final addressResponse = await _supabase
        .from('addresses')
        .insert({
      'address_id': _generateUuid(),
      'user_id': userIdForDb,
      'address_type': 'shipping',
      'is_default': true,
      'first_name': shippingAddress.firstName ?? '',
      'last_name': shippingAddress.lastName ?? '',
      'phone': shippingAddress.phone ?? '',
      'email': shippingAddress.email ?? fallbackEmail ?? '',
      'street_address': shippingAddress.streetAddress ?? '',
      'apartment': shippingAddress.apartment ?? '',
      'city': shippingAddress.city ?? '',
      'state': shippingAddress.state ?? '',
      'postal_code': shippingAddress.postalCode ?? '',
      'country': shippingAddress.country ?? 'US',
      'created_at': DateTime.now().toIso8601String(),
    })
        .select('address_id')
        .single();

    final shippingAddressId = addressResponse['address_id'];
    print('Created shipping address with ID: $shippingAddressId');
    return shippingAddressId;
  }

  // Create order record
  Future<String> _createOrderRecord({
    required String userIdForDb,
    required String? shippingAddressId,
    required double subtotal,
    required double tax,
    required double shipping,
    required double total,
  }) async {
    print('Creating order record...');

    // Generate an order number (text format, not UUID)
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    final orderData = {
      'user_id': userIdForDb,
      'order_number': orderNumber, // Text format order number
      'subtotal': subtotal,
      'tax_amount': tax,
      'shipping_amount': shipping,
      'discount_amount': 0, // Required field
      'total_amount': total,
      'status': 'PENDING', // Text status
      'placed_at': DateTime.now().toIso8601String(),
    };

    // Add shipping address if available
    if (shippingAddressId != null) {
      orderData['shipping_address_id'] = shippingAddressId;
    }

    print('Order data: $orderData');

    final orderResponse = await _supabase
        .from('orders')
        .insert(orderData)
        .select('order_id')
        .single();

    final orderId = orderResponse['order_id'];
    print('Created order with ID: $orderId');
    return orderId;
  }

  // Create payment record
  Future<void> _createPaymentRecord(String orderId, double total) async {
    print('Creating payment record...');

    // Generate a UUID for the payment_id and order_payment_id
    final paymentUuid = _generateUuid();
    final orderPaymentUuid = _generateUuid();

    // Create a payment record with UUID for payment_id
    final paymentData = {
      'order_payment_id': orderPaymentUuid,
      'order_id': orderId,
      'payment_id': paymentUuid, // Use UUID instead of string
      'amount': total,
      'is_refund': false,
      'created_at': DateTime.now().toIso8601String(),
    };

    await _supabase
        .from('order_payments')
        .insert(paymentData);

    print('Created payment record for order');
  }

  // Create order items
  Future<void> _createOrderItems(String orderId, List<dynamic> products) async {
    print('Creating order items...');
    for (var product in products) {
      try {
        // Generate UUID for order_item_id
        final orderItemId = _generateUuid();

        await _supabase
            .from('order_items')
            .insert({
          'order_item_id': orderItemId,
          'order_id': orderId,
          'product_id': product.id,
          'product_name': product.name,
          'quantity': product.quantity,
          'unit_price': product.price, // Use unit_price instead of price
          'subtotal': product.price * product.quantity,
          'discount_amount': 0, // Required field
          'tax_amount': (product.price * product.quantity) * 0.1, // Example tax calculation
          'total': product.price * product.quantity, // Total for this item
        });
        print('Added item ${product.id} to order');
      } catch (e) {
        print('Error adding item ${product.id}: $e');
        // Continue with other items even if one fails
      }
    }
  }

  // Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      print('Getting orders for auth_id: $userId');

      // Get the current authenticated user's email
      final session = _supabase.auth.currentSession;
      String? authEmail;

      if (session != null && session.user.id == userId) {
        authEmail = session.user.email;
        print('Found authenticated user email for order lookup: $authEmail');
      }

      // First try to find user by email if available
      var userQuery = [];
      if (authEmail != null) {
        print('Looking up user by email first: $authEmail');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email')
            .eq('email', authEmail);

        if (userQuery.isNotEmpty) {
          print('Found user by email: ${userQuery[0]['user_id']} with email: ${userQuery[0]['email']}');
        }
      }

      // If not found by email, try by auth_id
      if (userQuery.isEmpty) {
        print('User not found by email, trying by auth_id: $userId');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email')
            .eq('auth_id', userId);
      }

      // If we still can't find the user, return empty list
      if (userQuery.isEmpty) {
        print('User not found in database, returning empty orders list');
        return [];
      }

      final userIdForQuery = userQuery[0]['user_id'];
      print('Using user_id for query: $userIdForQuery');

      // Get orders with basic info only
      final dynamic rawResponse = await _supabase
          .from('orders')
          .select('*')
          .eq('user_id', userIdForQuery)
          .order('placed_at', ascending: false);

      // Convert response to the correct type
      final List<Map<String, dynamic>> response = List<Map<String, dynamic>>.from(
          (rawResponse as List).map((item) => Map<String, dynamic>.from(item as Map))
      );

      return response;
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  // Get order details
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      // Get order without items
      final dynamic orderBaseResponse = await _supabase
          .from('orders')
          .select('*, shipping_address:shipping_address_id(*)')
          .eq('order_id', orderId)
          .single();

      // Ensure orderBaseResponse is a Map<String, dynamic>
      final Map<String, dynamic> typedOrderResponse =
      Map<String, dynamic>.from(orderBaseResponse as Map);

      // Get order items separately with product information
      final dynamic orderItemsResponse = await _supabase
          .from('order_items')
          .select('*, product:product_id(*)')
          .eq('order_id', orderId);

      // Process the items
      final List<Map<String, dynamic>> processedItems = [];

      if (orderItemsResponse != null && orderItemsResponse is List) {
        print('Found ${orderItemsResponse.length} order items');

        for (var rawItem in orderItemsResponse) {
          // Ensure item is a Map<String, dynamic>
          final Map<String, dynamic> item = Map<String, dynamic>.from(
              rawItem as Map);

          // Get product information if available
          final product = item['product'];
          String? imageUrl;

          if (product != null && product is Map) {
            imageUrl = product['image_url'];
          }

          // Create a processed item with all needed fields
          final Map<String, dynamic> processedItem = {
            ...item,
            'product_name': item['product_name'] ?? 'Unknown Product',
            'unit_price': item['unit_price'] ?? 0.0,
            'total': item['total'] ?? 0.0,
            'image_url': imageUrl,
          };

          processedItems.add(processedItem);
        }
      }

      // Add the processed items to the order response
      typedOrderResponse['order_items'] = processedItems;

      return typedOrderResponse;
    } catch (e) {
      print('Error fetching order details: $e');
      rethrow;
    }
  }

  // Initiate a return
  Future<void> initiateReturn(String orderId, List<String> itemIds) async {
    try {
      // First, create a return record
      final returnResponse = await _supabase
          .from('returns')
          .insert({
        'order_id': orderId,
        'status': 'PENDING',
        'created_at': DateTime.now().toIso8601String(),
      })
          .select('return_id')
          .single();

      final returnId = returnResponse['return_id'];

      // Add each item to the return_items table
      final returnItems = itemIds.map((itemId) =>
      {
        'return_id': returnId,
        'order_item_id': itemId,
      }).toList();

      await _supabase
          .from('return_items')
          .insert(returnItems);

      // Update the order status to indicate a return is in progress
      await _supabase
          .from('orders')
          .update({'status': 'RETURN_PENDING'})
          .eq('order_id', orderId);
    } catch (e) {
      print('Error initiating return: $e');
      rethrow;
    }
  }

  // Create order
  Future<Order> createOrder(Order order) async {
    try {
      // Generate an order number (text format, not UUID)
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      // Insert order
      final orderResponse = await _supabase
          .from('orders')
          .insert({
        'user_id': order.userId,
        'order_number': orderNumber, // Text format order number
        'status': order.status,
        'subtotal': order.subtotal,
        'tax_amount': order.taxAmount,
        'shipping_amount': order.shipping_amount,
        'discount_amount': 0, // Required field
        'total_amount': order.totalAmount,
      })
          .select()
          .single();

      final newOrderId = orderResponse['order_id'];

      // Insert order items
      for (var item in order.items) {
        await _supabase
            .from('order_items')
            .insert({
          'order_item_id': _generateUuid(),
          'order_id': newOrderId,
          'product_id': item.productId,
          'product_name': item.productName,
          'quantity': item.quantity,
          'unit_price': item.price,
          'subtotal': item.price * item.quantity,
          'discount_amount': 0,
          'tax_amount': (item.price * item.quantity) * 0.1,
          'total': item.price * item.quantity,
        });
      }

      // Return the created order with items
      final newOrder = await getOrderDetails(newOrderId);
      return Order.fromJson(newOrder!);
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }
}
