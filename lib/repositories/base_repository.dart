import 'package:supabase_flutter/supabase_flutter.dart';

// Base repository class that provides common functionality for all repositories
class BaseRepository {
  final SupabaseClient client;

  BaseRepository({SupabaseClient? client})
      : this.client = client ?? Supabase.instance.client;

  // Protected method for standardized error handling
  Future<T> handleRepositoryOperation<T>(
      String operation,
      Future<T> Function() action, {
        required T defaultValue,
        bool throwError = false,
      }) async {
    try {
      return await action();
    } catch (e) {
      print('Repository error $operation: $e');
      if (throwError) {
        rethrow;
      }
      return defaultValue;
    }
  }

  // Common CRUD operations
  Future<Map<String, dynamic>?> getById(String table, String id, {String idField = 'id'}) async {
    return handleRepositoryOperation(
      'getting $table by ID',
          () async {
        final response = await client
            .from(table)
            .select()
            .eq(idField, id)
            .maybeSingle();
        return response;
      },
      defaultValue: null,
    );
  }

  Future<List<Map<String, dynamic>>> getAll(String table, {String orderBy = 'created_at', bool ascending = false}) async {
    return handleRepositoryOperation(
      'getting all $table',
          () async {
        final response = await client
            .from(table)
            .select()
            .order(orderBy, ascending: ascending);

        return List<Map<String, dynamic>>.from(response);
      },
      defaultValue: <Map<String, dynamic>>[],
    );
  }

  Future<String?> insert(String table, Map<String, dynamic> data, {String idField = 'id'}) async {
    return handleRepositoryOperation(
      'inserting into $table',
          () async {
        final response = await client
            .from(table)
            .insert(data)
            .select(idField)
            .single();

        return response[idField];
      },
      defaultValue: null,
    );
  }

  Future<bool> update(String table, String id, Map<String, dynamic> data, {String idField = 'id'}) async {
    return handleRepositoryOperation(
      'updating $table',
          () async {
        await client
            .from(table)
            .update(data)
            .eq(idField, id);
        return true;
      },
      defaultValue: false,
    );
  }

  Future<bool> delete(String table, String id, {String idField = 'id'}) async {
    return handleRepositoryOperation(
      'deleting from $table',
          () async {
        await client
            .from(table)
            .delete()
            .eq(idField, id);
        return true;
      },
      defaultValue: false,
    );
  }
}
