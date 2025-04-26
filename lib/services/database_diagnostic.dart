import 'package:supabase_flutter/supabase_flutter.dart';
import 'base_service.dart';

class DatabaseDiagnostic extends BaseService {
  final SupabaseClient _supabase;

  DatabaseDiagnostic(this._supabase);

  Future<void> runDiagnostic() async {
    logServiceActivity('Starting database diagnostic');

    try {
      // Test if we can access the users table
      logServiceActivity('Testing users table access');
      try {
        final usersResponse = await handleServiceOperation(
          'accessing users table',
              () => _supabase.from('users').select('user_id').limit(1),
          defaultValue: null,
        );
        logServiceActivity('Users table accessible', 'Response: $usersResponse');
      } catch (e) {
        logServiceActivity('Error accessing users table', e.toString());
      }

      // Test if we can access the orders table
      logServiceActivity('Testing orders table access');
      try {
        final ordersResponse = await handleServiceOperation(
          'accessing orders table',
              () => _supabase.from('orders').select('order_id').limit(1),
          defaultValue: null,
        );
        logServiceActivity('Orders table accessible', 'Response: $ordersResponse');
      } catch (e) {
        logServiceActivity('Error accessing orders table', e.toString());
      }

      // Test if we can access the order_items table
      logServiceActivity('Testing order_items table access');
      try {
        final orderItemsResponse = await handleServiceOperation(
          'accessing order_items table',
              () => _supabase.from('order_items').select('order_item_id').limit(1),
          defaultValue: null,
        );
        logServiceActivity('Order items table accessible', 'Response: $orderItemsResponse');
      } catch (e) {
        logServiceActivity('Error accessing order_items table', e.toString());
      }

      // Test if we can insert a test record and then delete it
      logServiceActivity('Testing insert capability');
      try {
        final testResponse = await handleServiceOperation(
          'inserting test record',
              () async {
            final response = await _supabase
                .from('users')
                .insert({
              'email': 'test_diagnostic@example.com',
              'user_type': 'test',
              'created_at': DateTime.now().toIso8601String(),
            })
                .select('user_id')
                .single();
            return response;
          },
          defaultValue: null,
        );

        if (testResponse != null) {
          final testId = testResponse['user_id'];
          logServiceActivity('Insert successful', 'Test ID: $testId');

          // Delete the test record
          await handleServiceOperation(
            'deleting test record',
                () => _supabase.from('users').delete().eq('user_id', testId),
            defaultValue: null,
          );
          logServiceActivity('Delete successful');
        }
      } catch (e) {
        logServiceActivity('Error testing insert', e.toString());
      }
    } catch (e) {
      logServiceActivity('Error running diagnostics', e.toString());
    }

    logServiceActivity('Database diagnostic completed');
  }
}
