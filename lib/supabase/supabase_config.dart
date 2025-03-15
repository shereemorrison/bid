import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCredentials {
  static const String url = 'https://bumnygblvvxzphlgxnco.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ1bW55Z2JsdnZ4enBobGd4bmNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIwMDI2OTcsImV4cCI6MjA1NzU3ODY5N30.Qc76cKaG-gUr9U0oQwGIOk1ovm5gTyXKPwRauMKu7-o';
}

class SupabaseConfig {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseCredentials.url,
      anonKey: SupabaseCredentials.anonKey,
    );
  }
}