import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Service responsible for handling order returns
class OrderReturnService {
  final SupabaseClient _supabase;

  OrderReturnService(this._supabase);

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
}
