import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      // First, let's check if the user exists and get their numeric ID if needed
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
          .select('*')
          .eq('user_id', userIdForQuery)
          .order('placed_at', ascending: false);

      // Print the raw response for debugging
      print('Raw response from Supabase: $rawResponse');

      // Convert the response to the correct type
      final List<Map<String, dynamic>> response = List<Map<String, dynamic>>.from(
          (rawResponse as List).map((item) => Map<String, dynamic>.from(item as Map))
      );

      return response;
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      // Get the order with its items
      final dynamic rawResponse = await _supabase
          .from('orders')
          .select('''
            *,
            order_items(*),
            order_status!status_id(*)
          ''')
          .eq('order_id', orderId)
          .limit(1);

      // Print the raw response for debugging
      print('Raw order details response: $rawResponse');

      // Convert the response to the correct type
      final List<Map<String, dynamic>> response = List<Map<String, dynamic>>.from(
          (rawResponse as List).map((item) => Map<String, dynamic>.from(item as Map))
      );

      if (response.isEmpty) {
        return null;
      }

      return response.first;
    } catch (e) {
      print('Error fetching order details: $e');
      rethrow;
    }
  }
}