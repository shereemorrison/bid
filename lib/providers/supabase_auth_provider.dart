import 'package:bid/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_service.dart';
import '../supabase/supabase_config.dart';

class SupabaseAuthProvider with ChangeNotifier {
  User? _user;
  String? _lastError;
  final UserService _userService = UserService();
  bool _isVerificationRequired = true;

  SupabaseAuthProvider() {
    _initializeAuth();
    _checkAuthConfig();
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  String? get lastError => _lastError;
  bool get isVerificationRequired => _isVerificationRequired;

  Future<void> _checkAuthConfig() async {
    try {
      _isVerificationRequired = true;
      notifyListeners();
    } catch (e) {
    }
  }

  void _initializeAuth() {
    _user = SupabaseConfig.client.auth.currentUser;

    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.userUpdated) {
        _user = session?.user;

        if (_user != null) {
          _ensureUserRecord();
        }
      } else if (event == AuthChangeEvent.signedOut) {
        _user = null;
      }

      notifyListeners();
    });
  }

  Future<void> _ensureUserRecord() async {
    if (_user == null) return;

    try {
      final userData = await _userService.getUserData(_user!.id);

      if (userData == null) {
        await _userService.createUser(
          authId: _user!.id,
          email: _user!.email ?? '',
          firstName: _user!.userMetadata?['first_name'] as String?,
          lastName: _user!.userMetadata?['last_name'] as String?,
          phone: _user!.userMetadata?['phone'] as String?,
        );
      } else {
        // User exists, update last login
        await _userService.updateLastLogin(_user!.id);
      }
    } catch (e) {
    }
  }

  Future<void> signUp(String email, String password, {String? firstName, String? lastName, String? phone}) async {
    try {
      _lastError = null;
      notifyListeners();

      final Map<String, dynamic> metadata = {};
      if (firstName != null && firstName.isNotEmpty) metadata['first_name'] = firstName;
      if (lastName != null && lastName.isNotEmpty) metadata['last_name'] = lastName;
      if (phone != null && phone.isNotEmpty) metadata['phone'] = phone;

      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      if (response.user != null) {
        _user = response.user;

        if (_isVerificationRequired && response.session == null) {
          return;
        }

        try {
          await _userService.createUser(
            authId: response.user!.id,
            email: email,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
          );
        } catch (dbError) {
          _lastError = "Database error: $dbError";
        }

        notifyListeners();
      } else {
        _lastError = "Auth signup returned null user";
      }
    } catch (e) {
      _lastError = "Error signing up: $e";
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _lastError = null;
      notifyListeners();

      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;

        await _ensureUserRecord();
      } else {
        _lastError = "Auth signin returned null user";
      }

      notifyListeners();
    } catch (e) {
      _lastError = "Error signing in: $e";
      rethrow;
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    try {
      await SupabaseConfig.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (e) {
      _lastError = "Error resending confirmation email: $e";
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _lastError = "Error signing out: $e";
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await SupabaseConfig.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      _lastError = "Error resetting password: $e";
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await SupabaseConfig.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      notifyListeners();
    } catch (e) {
      _lastError = "Error updating password: $e";
      rethrow;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await SupabaseConfig.client.auth.updateUser(
        UserAttributes(email: newEmail),
      );
      notifyListeners();
    } catch (e) {
      _lastError = "Error updating email: $e";
      rethrow;
    }
  }

  void notifyUserLoggedIn() {
    notifyListeners();
  }

}

