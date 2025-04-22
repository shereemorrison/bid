import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseDiagnostic {
  final SupabaseClient _supabase;

  DatabaseDiagnostic(this._supabase);

  Future<void> runDiagnostic() async {
    print('=== DATABASE DIAGNOSTIC ===');

    try {
      // Test if we can access the users table
      print('Testing users table access...');
      try {
        final usersResponse = await _supabase
            .from('users')
            .select('user_id')
            .limit(1)
            .execute();
        print('✅ Users table accessible. Response: ${usersResponse.data}');
      } catch (e) {
        print('❌ Error accessing users table: $e');
      }

      // Test if we can access the orders table
      print('Testing orders table access...');
      try {
        final ordersResponse = await _supabase
            .from('orders')
            .select('order_id')
            .limit(1)
            .execute();
        print('✅ Orders table accessible. Response: ${ordersResponse.data}');
      } catch (e) {
        print('❌ Error accessing orders table: $e');
      }

      // Test if we can access the order_items table
      print('Testing order_items table access...');
      try {
        final orderItemsResponse = await _supabase
            .from('order_items')
            .select('order_item_id')
            .limit(1)
            .execute();
        print('✅ Order items table accessible. Response: ${orderItemsResponse.data}');
      } catch (e) {
        print('❌ Error accessing order_items table: $e');
      }

      // Test if we can insert a test record and then delete it
      print('Testing insert capability...');
      try {
        final testResponse = await _supabase
            .from('users')
            .insert({
          'email': 'test_diagnostic@example.com',
          'user_type': 'test',
          'created_at': DateTime.now().toIso8601String(),
        })
            .select('user_id')
            .single();

        final testId = testResponse['user_id'];
        print('✅ Insert successful. Test ID: $testId');

        // Delete the test record
        await _supabase
            .from('users')
            .delete()
            .eq('user_id', testId);
        print('✅ Delete successful');
      } catch (e) {
        print('❌ Error testing insert: $e');
      }
    } catch (e) {
      print('Error running diagnostics: $e');
    }

    print('=== END DIAGNOSTIC ===');
  }
}
