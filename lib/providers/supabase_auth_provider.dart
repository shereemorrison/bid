
import 'package:bid/providers/order_provider.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/providers/user_provider.dart';
import 'package:bid/services/user_service.dart';
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
    _initAuthState();
  }

  Future<void> _initAuthState() async {
    Future.microtask(() async {
      final session = SupabaseConfig.client.auth.currentSession;
      if (session != null) {
        // First update the user ID
        _ref.read(authUserIdProvider.notifier).state = session.user.id;

        // Then update login state
        Future.microtask(() {
          _ref.read(isLoggedInProvider.notifier).state = true;
        });
      } else {
        _ref.read(authUserIdProvider.notifier).state = null;

        // Update in a separate microtask
        Future.microtask(() {
          _ref.read(isLoggedInProvider.notifier).state = false;
        });
      }
    });
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    _ref.read(authLoadingProvider.notifier).state = true;
    _ref.read(authErrorProvider.notifier).state = null;

    try {
      print('Attempting to sign in with email: $email');

      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final authId = response.user!.id;
        final userEmail = email; // Use the email they logged in with

        print('Successfully signed in with auth_id: $authId and email: $userEmail');

        _ref.read(isLoggedInProvider.notifier).state = true;
        _ref.read(authUserIdProvider.notifier).state = authId;

      // Update auth_id with last login
      try {
        final userService = UserService();
        final existingUserId = await userService.findUserIdByEmail(userEmail);

        if (existingUserId != null) {
          print('Found existing user with email $userEmail, updating auth_id');
          // Update the existing user's auth_id to match the current session
          await SupabaseConfig.client
              .from('users')
              .update({'auth_id': authId})
              .eq('user_id', existingUserId);
        } else {
          print(
              'No user record found for email $userEmail during login. This is unexpected.');
        }

        // Update user data in provider
        await _ref.read(userNotifierProvider.notifier).updateUserData(authId);
      } catch (e) {
        print('Error updating user record: $e');
        // Continue with login even if user record update fails
      }
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

      // Create new user record in database
      try {
        final userService = UserService();
        await userService.createUser(
          authId: response.user!.id,
          email: email,
          firstName: firstName,
          lastName: lastName,
        );

        // Update user data in provider
        await _ref.read(userNotifierProvider.notifier).updateUserData(
            response.user!.id);
      } catch (e) {
        print('Error creating user record: $e');
      }
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
      // Clear all state first before signing out
      try {
        // Clear user data
        _ref.read(userDataProvider.notifier).state = null;

        // Reset the cart state
        _ref.read(cartProvider.notifier).state = [];
        _ref.read(cartTabIndexProvider.notifier).state = 0;

        // Clear wishlist
        _ref.read(wishlistProvider.notifier).state = [];

        // Clear orders data
        _ref.read(orderNotifierProvider.notifier).clearOrders();

        print('Successfully cleared all user data and cart before logout');
      } catch (e) {
        print('Error clearing user data: $e');
      }

      // Now sign out from Supabase
      await SupabaseConfig.client.auth.signOut();

      // Update auth state after sign out
      _ref.read(isLoggedInProvider.notifier).state = false;
      _ref.read(authUserIdProvider.notifier).state = null;
      _ref.read(authErrorProvider.notifier).state = null;

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
