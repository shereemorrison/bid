import 'package:bid/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service responsible for querying orders
class OrderQueryService {
  final SupabaseClient _supabase;

  OrderQueryService(this._supabase);

  // Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      // print('Getting orders for auth_id: $userId');

      // Get the current authenticated user's email
      final session = _supabase.auth.currentSession;
      String? authEmail;

      if (session != null && session.user.id == userId) {
        authEmail = session.user.email;
        // print('Found authenticated user email for order lookup: $authEmail');
      }

      // First try to find user by email if available
      var userQuery = [];
      if (authEmail != null) {
        // print('Looking up user by email first: $authEmail');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email')
            .eq('email', authEmail);

        if (userQuery.isNotEmpty) {
          // print('Found user by email: ${userQuery[0]['user_id']} with email: ${userQuery[0]['email']}');
        }
      }

      // If not found by email, try by auth_id
      if (userQuery.isEmpty) {
        // print('User not found by email, trying by auth_id: $userId');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email')
            .eq('auth_id', userId);
      }

      // If we still can't find the user, return empty list
      if (userQuery.isEmpty) {
        // print('User not found in database, returning empty orders list');
        return [];
      }

      final userIdForQuery = userQuery[0]['user_id'];
      // print('Using user_id for query: $userIdForQuery');

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
}
