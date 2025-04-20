
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../supabase/supabase_config.dart';

// State providers
final isLoggedInProvider = StateProvider<bool>((ref) => false);
final authUserIdProvider = StateProvider<String?>((ref) => null);
final authLoadingProvider = StateProvider<bool>((ref) => false);
final authErrorProvider = StateProvider<String?>((ref) => null);

// Controller notifier for complex auth operations
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.data(null)) {
    // Initialize auth state
    _initializeAuthState();
  }

  void _initializeAuthState() {
    final session = SupabaseConfig.client.auth.currentSession;
    if (session != null) {
      _ref.read(isLoggedInProvider.notifier).state = true;
      _ref.read(authUserIdProvider.notifier).state = session.user.id;
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _ref.read(authLoadingProvider.notifier).state = true;
    _ref.read(authErrorProvider.notifier).state = null;

    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _ref.read(isLoggedInProvider.notifier).state = true;
        _ref.read(authUserIdProvider.notifier).state = response.user!.id;
      } else {
        _ref.read(authErrorProvider.notifier).state = 'Failed to sign in';
      }
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  // Sign up with email and password
  Future<void> signUp(String email, String password, {String? firstName, String? lastName}) async {
    _ref.read(authLoadingProvider.notifier).state = true;
    _ref.read(authErrorProvider.notifier).state = null;

    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      if (response.user != null) {
        _ref.read(isLoggedInProvider.notifier).state = true;
        _ref.read(authUserIdProvider.notifier).state = response.user!.id;
      } else {
        _ref.read(authErrorProvider.notifier).state = 'Failed to sign up';
      }
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _ref.read(authLoadingProvider.notifier).state = true;

    try {
      await SupabaseConfig.client.auth.signOut();
      _ref.read(isLoggedInProvider.notifier).state = false;
      _ref.read(authUserIdProvider.notifier).state = null;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }
}

// Provider for the auth notifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref);
});
