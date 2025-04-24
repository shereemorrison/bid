import 'package:supabase_flutter/supabase_flutter.dart';

/// Base repository class that provides common functionality for all repositories
class BaseRepository {
  final SupabaseClient client;

  BaseRepository({SupabaseClient? client})
      : this.client = client ?? Supabase.instance.client;
}
