import 'package:bid/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      // Check if user exists and get Id if they do
      final userResponse = await _supabase
          .from('users')
          .select('user_id')
          .eq('auth_id', userId)
          .single();

      final userIdForQuery = userResponse['user_id'];
      print('Using user_id for query: $userIdForQuery');

      // Get orders with basic info only
      final dynamic rawResponse = await _supabase
          .from('orders')
          .select('''
          *,
          order_status(*)
          ''')
          .eq('user_id', userIdForQuery)
          .order('placed_at', ascending: false);

      // Convert response to the correct type
      final List<Map<String, dynamic>> response = List<
          Map<String, dynamic>>.from(
          (rawResponse as List).map((item) =>
          Map<String, dynamic>.from(item as Map))
      );

      return response;
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      // Get order without items
      final dynamic orderBaseResponse = await _supabase
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
      final dynamic orderItemsResponse = await _supabase
          .from('order_items')
          .select('''
          *,
          products(*)
        ''')
          .eq('order_id', orderId);

      // Process the items
      final List<Map<String, dynamic>> processedItems = [];

      if (orderItemsResponse != null && orderItemsResponse is List) {
        print('Found ${orderItemsResponse.length} order items');

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

          // Debug
          print(
              'Processing item: ${item['order_item_id']} - Product: ${product?['name'] ??
                  'Unknown'}');

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
      print('Error fetching order details: $e');
      rethrow;
    }
  }

  //  Initiate a return
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

  Future<Order> createOrder(Order order) async {
    try {
      // Insert order
      final orderResponse = await _supabase
          .from('orders')
          .insert({
        'user_id': order.userId,
        'status': order.status,
        'subtotal': order.subtotal,
        'tax_amount': order.taxAmount,
        'shipping_amount': order.shipping_amount,
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
          'order_id': newOrderId,
          'product_id': item.productId,
          'quantity': item.quantity,
          'price': item.price,
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
