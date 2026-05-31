import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://YOUR_PROJECT_REF.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';

  static GlobalKey<NavigatorState>? navigatorKey;

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
