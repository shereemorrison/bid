import 'package:bid/models/order_model.dart';
import 'package:bid/models/order_item_model.dart';
import 'package:bid/models/address_model.dart';
import 'package:bid/state/cart/cart_state.dart';
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository extends BaseRepository {
  OrderRepository({SupabaseClient? client}) : super(client: client);

  // Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders(String authId) async {
    try {
      print('OrderRepository: Fetching orders for auth ID: $authId');

      // Get user_id from auth_id
      final userResponse = await client
          .from('users')
          .select('user_id')
          .eq('auth_id', authId)
          .single();

      if (userResponse == null) {
        print('OrderRepository: No user found for auth ID: $authId');
        return [];
      }

      final userIdForQuery = userResponse['user_id'];
      print('OrderRepository: Using user_id for query: $userIdForQuery');

      if (userIdForQuery == null) {
        print('OrderRepository: user_id is null for auth ID: $authId');
        return [];
      }

      // Get orders with basic info
      final dynamic rawResponse = await client
          .from('orders')
          .select('''
          *,
          order_status(*)
          ''')
          .eq('user_id', userIdForQuery)
          .order('placed_at', ascending: false);

      if (rawResponse == null) {
        print('OrderRepository: No orders found for user_id: $userIdForQuery');
        return [];
      }

      // Convert response to the correct type
      final List<Map<String, dynamic>> response = List<
          Map<String, dynamic>>.from(
          (rawResponse as List).map((item) =>
          Map<String, dynamic>.from(item as Map))
      );

      print('OrderRepository: Found ${response.length} orders');

      // Add user_id to each order if it's missing
      for (var order in response) {
        if (!order.containsKey('user_id') || order['user_id'] == null) {
          order['user_id'] = userIdForQuery;
        }
      }

      return response;
    } catch (e) {
      print('OrderRepository: Error fetching orders: $e');
      return []; // Return empty list on error
    }
  }

  // Create a new order
  Future<String?> createOrder(Order order) async {
    try {
      final orderData = order.toJson();
      final orderResponse = await client
          .from('orders')
          .insert(orderData)
          .select('order_id')
          .single();

      final orderId = orderResponse['order_id'];

      // Create order items
      final orderItems = order.items.map((item) =>
      {
        'order_id': orderId,
        'product_id': item.productId,
        'quantity': item.quantity,
        'price': item.price,
        'product_name': item.name,
        'image_url': item.imageUrl,
      }).toList();

      await client.from('order_items').insert(orderItems);

      return orderId;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  // Create order from checkout data
  Future<Map<String, dynamic>> createOrderFromCheckout({
    required String userId,
    required List<CartItem> products,
    required Address shippingAddress,
    required double subtotal,
    required double tax,
    required double shipping,
    required double total,
    required String paymentMethod,
    required String paymentIntentId,
    required bool isGuestCheckout,
  }) async {
    try {
      // Create order items from cart items
      final orderItems = products.map((item) =>
          OrderItem(
            itemId: DateTime
                .now()
                .millisecondsSinceEpoch
                .toString() + '_' + item.productId,
            productId: item.productId,
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            imageUrl: item.imageUrl,
          )).toList();

      // Convert shipping address to JSON for storage
      final shippingAddressJson = shippingAddress.toJson();

      // Create the order object using your existing Order model
      final order = Order(
        orderId: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        userId: userId,
        orderDate: DateTime.now(),
        status: 'PENDING',
        taxAmount: tax,
        shippingAmount: shipping,
        discountAmount: 0.0,
        totalAmount: total,
        shippingMethod: 'Standard',
        items: orderItems,
        shippingAddress: shippingAddressJson,
        paymentMethod: paymentMethod,
      );

      // Create the order using the existing method
      final createdOrderId = await createOrder(order);

      if (createdOrderId != null) {
        return {
          'success': true,
          'order_id': createdOrderId,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to create order',
        };
      }
    } catch (e) {
      print('Error creating order from checkout: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get order details
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      // Get order without items
      final dynamic orderBaseResponse = await client
          .from('orders')
          .select('''
          *,
          order_status(*)
        ''')
          .eq('order_id', orderId)
          .single();

      // Ensure orderBaseResponse is a Map<String, dynamic>
      final Map<String, dynamic> typedOrderResponse =
      Map<String, dynamic>.from(orderBaseResponse as Map);

      // Get order items separately
      final dynamic orderItemsResponse = await client
          .from('order_items')
          .select('''
          *,
          products(*)
        ''')
          .eq('order_id', orderId);

      // Process the items
      final List<Map<String, dynamic>> processedItems = [];

      if (orderItemsResponse != null && orderItemsResponse is List) {
        print(
            'OrderRepository: Found ${orderItemsResponse.length} order items');

        for (var rawItem in orderItemsResponse) {
          // Ensure item is a Map<String, dynamic>
          final Map<String, dynamic> item = Map<String, dynamic>.from(
              rawItem as Map);

          // Get the product data, ensuring it's a Map<String, dynamic> if not null
          final dynamic rawProduct = item['products'];
          final Map<String, dynamic>? product =
          rawProduct != null
              ? Map<String, dynamic>.from(rawProduct as Map)
              : null;

          // Create a processed item with all needed fields
          final Map<String, dynamic> processedItem = {
            ...item,
            'product_name': product != null
                ? product['name']
                : item['product_name'] ?? 'Unknown Product',
            'price': item['price'] ??
                (product != null ? product['price'] : 0.0),
            'image_url': product != null
                ? product['image_url']
                : item['image_url'],
          };

          processedItems.add(processedItem);
        }
      }

      // Add the processed items to the order response
      typedOrderResponse['order_items'] = processedItems;

      return typedOrderResponse;
    } catch (e) {
      print('OrderRepository: Error fetching order details: $e');
      return null;
    }
  }

  // Initiate return
  Future<bool> initiateReturn(String orderId, List<String> itemIds) async {
    try {
      // First, create a return record
      final returnResponse = await client
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

      await client
          .from('return_items')
          .insert(returnItems);

      // Update the order status to indicate a return is in progress
      await client
          .from('orders')
          .update({'status': 'RETURN_PENDING'})
          .eq('order_id', orderId);

      return true;
    } catch (e) {
      print('OrderRepository: Error initiating return: $e');
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await client
          .from('orders')
          .update({'status': status})
          .eq('order_id', orderId);
      return true;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  // Debugging
  Future<void> inspectDatabase() async {
    try {
      print('OrderRepository: Inspecting database...');

      // Check users table
      final users = await client
          .from('users')
          .select('user_id, auth_id, first_name, last_name')
          .limit(5);

      print('OrderRepository: Sample users: $users');

      // Check orders table
      final orders = await client
          .from('orders')
          .select('order_id, user_id, status')
          .limit(5);

      print('OrderRepository: Sample orders: $orders');

      // Check order_items table
      final orderItems = await client
          .from('order_items')
          .select('order_item_id, order_id, product_id')
          .limit(5);

      print('OrderRepository: Sample order items: $orderItems');
    } catch (e) {
      print('OrderRepository: Error inspecting database: $e');
    }
  }
  //Guest orders
  Future<String?> createGuestOrder({
    required String? userId,
    required String guestEmail,
    required List<OrderItem> items,
    required Map<String, dynamic> shippingAddress,
    required double subtotal,
    required double tax,
    required double shipping,
    required double total,
    required String paymentMethod,
    String? paymentIntentId,
  }) async {
    try {
      // Generate an order number
      final orderNumber = 'ORD-${DateTime
          .now()
          .year}${DateTime
          .now()
          .month
          .toString()
          .padLeft(2, '0')}${DateTime
          .now()
          .day
          .toString()
          .padLeft(2, '0')}-${(DateTime
          .now()
          .millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0')}';

      // Create the order
      final orderData = {
        'user_id': userId, // Can be null for completely guest checkout
        'guest_email': guestEmail, // Store email for lookup
        'order_number': orderNumber,
        'status': 'PENDING',
        'subtotal': subtotal.toString(),
        'tax_amount': tax.toString(),
        'shipping_amount': shipping.toString(),
        'discount_amount': '0.00',
        'total_amount': total.toString(),
        'shipping_method': 'Standard',
        'placed_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'payment_intent_id': paymentIntentId,
        'metadata': {
          'shipping_address': shippingAddress,
          'is_guest_order': true,
        },
      };

      final orderResponse = await client
          .from('orders')
          .insert(orderData)
          .select('order_id')
          .single();

      final orderId = orderResponse['order_id'];

      // Create order items
      final orderItems = items.map((item) =>
      {
        'order_id': orderId,
        'product_id': item.productId,
        'variant_id': null,
        // Add if you have this
        'product_name': item.name,
        'variant_name': null,
        // Add if you have this
        'sku': 'SKU-${item.productId.substring(0, 8)}',
        'quantity': item.quantity,
        'unit_price': item.price.toString(),
        'subtotal': (item.price * item.quantity).toString(),
        'discount_amount': '0.00',
        'tax_amount': (item.price * item.quantity * 0.1).toString(),
        // Assuming 10% tax
        'total': (item.price * item.quantity * 1.1).toString(),
        // Price + tax
      }).toList();

      await client.from('order_items').insert(orderItems);

      return orderId;
    } catch (e) {
      print('Error creating guest order: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    try {
      final response = await client
          .from('orders')
          .select('''
          *,
          order_items(*)
        ''')
          .eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting orders by user ID: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      final response = await client
          .from('orders')
          .select('''
          *,
          order_items(*)
        ''')
          .eq('order_id', orderId)
          .maybeSingle();

      return response != null ? Map<String, dynamic>.from(response) : null;
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }

  Future<bool> updateOrderUserId(String orderId, String newUserId) async {
    try {
      await client
          .from('orders')
          .update({
        'user_id': newUserId,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('order_id', orderId);

      return true;
    } catch (e) {
      print('Error updating order user ID: $e');
      return false;
    }
  }
}
