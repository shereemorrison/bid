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

      // Convert the response to the correct type
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
      // Get the order with its items
      final dynamic orderResponse = await _supabase
          .from('orders')
          .select('''
          *,
          order_items(*),
          order_status(*)
        ''')
          .eq('order_id', orderId)
          .single();

      return orderResponse;
    } catch (e) {
      print('Error fetching order details: $e');
      rethrow;
    }
  }
}
