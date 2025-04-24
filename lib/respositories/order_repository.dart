import 'package:bid/models/order_model.dart';
import 'package:bid/models/order_item_model.dart';
import 'package:bid/models/address_model.dart';
import 'package:bid/state/cart/cart_state.dart';
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository extends BaseRepository {
  OrderRepository({SupabaseClient? client}) : super(client: client);

  // Get user orders - cleaned up version that works
  Future<List<Map<String, dynamic>>> getUserOrders(String authId) async {
    try {
      print('OrderRepository: Fetching orders for auth ID: $authId');

      // Get user_id from auth_id
      final userResponse = await client
          .from('users')
          .select('user_id')
          .eq('auth_id', authId)
          .single();

      final userIdForQuery = userResponse['user_id'];
      print('OrderRepository: Using user_id for query: $userIdForQuery');

      // Get orders with basic info
      final dynamic rawResponse = await client
          .from('orders')
          .select('''
          *,
          order_status(*)
          ''')
          .eq('user_id', userIdForQuery)
          .order('placed_at', ascending: false);

      // Convert response to the correct type
      final List<Map<String, dynamic>> response = List<Map<String, dynamic>>.from(
          (rawResponse as List).map((item) => Map<String, dynamic>.from(item as Map))
      );

      print('OrderRepository: Found ${response.length} orders');
      return response;
    } catch (e) {
      print('OrderRepository: Error fetching orders: $e');
      return []; // Return empty list instead of rethrowing
    }
  }

  // Create a new order
  Future<String?> createOrder(Order order) async {
    try {
      // First create the order
      final orderData = order.toJson();
      final orderResponse = await client
          .from('orders')
          .insert(orderData)
          .select('order_id')
          .single();

      final orderId = orderResponse['order_id'];

      // Then create order items
      final orderItems = order.items.map((item) => {
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
      final orderItems = products.map((item) => OrderItem(
        itemId: DateTime.now().millisecondsSinceEpoch.toString() + '_' + item.productId,
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
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
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
        print('OrderRepository: Found ${orderItemsResponse.length} order items');

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

          // Check if item has been returned
          final dynamic returnItems = item['return_items'];
          String? returnStatus;
          if (returnItems != null && returnItems is List && returnItems.isNotEmpty) {
            // Get the latest return status
            final latestReturn = returnItems.last;
            returnStatus = latestReturn['status'] ?? 'PENDING';
          }

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
            'return_status': returnStatus,
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

  // Basic database inspection for troubleshooting
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
}
