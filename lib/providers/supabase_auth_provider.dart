import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _user = SupabaseConfig.client.auth.currentUser;

    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.userUpdated) {
        _user = session?.user;
      } else if (event == AuthChangeEvent.signedOut) {
        _user = null;
      }

      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error signing in: $e");
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error signing up: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await SupabaseConfig.client.auth.signOut();
  }
}

