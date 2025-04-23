import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../providers/checkout_auth_state.dart';
import '../services/checkout_session_manager.dart';
import '../services/user_service.dart';
import '../providers/shop_provider.dart';
import '../providers/address_provider.dart';

/// Centralized authentication service that serves as the single source of truth
/// for authentication state throughout the application.
class AuthService {
  final SupabaseClient _supabase;
  final riverpod.Ref _ref;
  final UserService _userService;
  final CheckoutSessionManager _sessionManager;

  AuthService(this._supabase, this._ref, this._userService, this._sessionManager);

  // State providers - these will be the only providers for auth state
  final _isLoggedInProvider = riverpod.StateProvider<bool>((ref) => false);
  final _authUserIdProvider = riverpod.StateProvider<String?>((ref) => null);
  final _authLoadingProvider = riverpod.StateProvider<bool>((ref) => false);
  final _authErrorProvider = riverpod.StateProvider<String?>((ref) => null);
  final _userProvider = riverpod.StateProvider<UserModel?>((ref) => null);

  // Getters for the providers - other components should use these
  riverpod.StateProvider<bool> get isLoggedInProvider => _isLoggedInProvider;
  riverpod.StateProvider<String?> get authUserIdProvider => _authUserIdProvider;
  riverpod.StateProvider<bool> get authLoadingProvider => _authLoadingProvider;
  riverpod.StateProvider<String?> get authErrorProvider => _authErrorProvider;
  riverpod.StateProvider<UserModel?> get userProvider => _userProvider;

  // Initialize auth state
  Future<void> initAuthState() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      final authId = session.user.id;

      // Update auth state
      _ref.read(_authUserIdProvider.notifier).state = authId;
      _ref.read(_isLoggedInProvider.notifier).state = true;

      // Load user data
      await _loadUserData(authId);
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    _ref.read(_authLoadingProvider.notifier).state = true;
    _ref.read(_authErrorProvider.notifier).state = null;

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final authId = response.user!.id;

        // Clear any guest data before updating auth state
        await _clearGuestDataOnLogin(authId);

        // Update auth state
        _ref.read(_authUserIdProvider.notifier).state = authId;
        _ref.read(_isLoggedInProvider.notifier).state = true;

        // Load user data
        await _loadUserData(authId);

        // Update last login timestamp
        await _userService.updateLastLogin(authId);
      } else {
        _ref.read(_authErrorProvider.notifier).state = 'Failed to sign in';
      }

      return response;
    } catch (e) {
      _ref.read(_authErrorProvider.notifier).state = e.toString();
      rethrow;
    } finally {
      _ref.read(_authLoadingProvider.notifier).state = false;
    }
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    Map<String, dynamic>? additionalData,
  }) async {
    _ref.read(_authLoadingProvider.notifier).state = true;
    _ref.read(_authErrorProvider.notifier).state = null;

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          ...?additionalData,
        },
      );

      if (response.user != null) {
        final authId = response.user!.id;

        // Clear any guest data before updating auth state
        await _clearGuestDataOnLogin(authId);

        // Update auth state
        _ref.read(_authUserIdProvider.notifier).state = authId;
        _ref.read(_isLoggedInProvider.notifier).state = true;

        // Create user profile in database
        await _userService.createUser(
          authId: authId,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );

        // Load user data
        await _loadUserData(authId);
      } else {
        _ref.read(_authErrorProvider.notifier).state = 'Failed to sign up';
      }

      return response;
    } catch (e) {
      _ref.read(_authErrorProvider.notifier).state = e.toString();
      rethrow;
    } finally {
      _ref.read(_authLoadingProvider.notifier).state = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _ref.read(_authLoadingProvider.notifier).state = true;

    try {
      // Clear all user data first
      await _clearAllUserData();

      // Then sign out from Supabase
      await _supabase.auth.signOut();

      // Update auth state
      _ref.read(_isLoggedInProvider.notifier).state = false;
      _ref.read(_authUserIdProvider.notifier).state = null;
      _ref.read(_userProvider.notifier).state = null;
      _ref.read(_authErrorProvider.notifier).state = null;
    } catch (e) {
      _ref.read(_authErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(_authLoadingProvider.notifier).state = false;
    }
  }

  // Convert guest to registered user
  Future<bool> convertGuestToRegistered({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Get current checkout session
      final currentSession = _sessionManager.getCurrentSession();

      if (currentSession == null || !currentSession.isGuestCheckout) {
        print('No guest checkout session to convert');
        return false;
      }

      // Register the user with Supabase Auth
      final response = await signUpWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        additionalData: additionalData,
      );

      if (response.user == null) {
        print('Failed to create user account');
        return false;
      }

      final authId = response.user!.id;

      // Update the checkout session with the new user ID
      _sessionManager.updateSessionUser(authId);

      print('Successfully converted guest checkout to registered user');
      return true;
    } catch (e) {
      print('Error converting guest to registered user: $e');
      return false;
    }
  }

  // Load user data
  Future<void> _loadUserData(String authId) async {
    try {
      final userData = await _userService.getUserData(authId);
      _ref.read(_userProvider.notifier).state = userData;
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Clear guest data when a user logs in
  Future<void> _clearGuestDataOnLogin(String authId) async {
    try {
      // ADDED: Explicitly clear address data first
      _clearAddressData();

      // Check if there's an active checkout session for a guest
      final currentSession = _sessionManager.getCurrentSession();

      if (currentSession != null && currentSession.isGuestCheckout) {
        // Store the shipping address temporarily if needed
        // REMOVED: We don't want to preserve the guest shipping address
        // final shippingAddress = currentSession.shippingAddress;

        // Clear the guest checkout session
        _sessionManager.clearCheckoutSession();
        print('Cleared guest checkout session on login');

        // Initialize a new session for the logged-in user
        // CHANGED: Don't preserve shipping address from guest
        _sessionManager.initializeCheckoutSession(
          userId: authId,
          isGuestCheckout: false,
        );
      } else if (currentSession == null) {
        // Initialize a new session for the logged-in user
        _sessionManager.initializeCheckoutSession(
          userId: authId,
          isGuestCheckout: false,
        );
      }

      // ADDED: Reset cart tab index to ensure we start at the bag tab
      _ref.read(cartTabIndexProvider.notifier).state = 0;
    } catch (e) {
      print('Error clearing guest data: $e');
    }
  }

  // Clear all user data (for logout)
  Future<void> _clearAllUserData() async {
    try {
      // ADDED: Clear address data first
      _clearAddressData();

      // Clear checkout session and create a new guest session
      _sessionManager.clearCheckoutSession();
      _sessionManager.initializeCheckoutSession(isGuestCheckout: true);

      // Clear cart and wishlist
      _clearCartAndWishlist();

      // ADDED: Reset shipping cost provider if it exists
      try {
        if (_ref.exists(shippingCostProvider)) {
          _ref.read(shippingCostProvider.notifier).state = 0.0;
        }
      } catch (e) {
        print('Error resetting shipping cost: $e');
      }

      // ADDED: Reset checkout tab index
      _ref.read(cartTabIndexProvider.notifier).state = 0;

      print('Successfully cleared all user data');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // ADDED: Helper method to clear address data
  void _clearAddressData() {
    try {
      // Clear address data using your existing address notifier
      if (_ref.exists(addressNotifierProvider)) {
        _ref.read(addressNotifierProvider.notifier).clearAddressData();
      }

      // Also clear the individual address providers directly
      // FIXED: Don't try to set state on effectiveAddressProvider (it's a computed provider)
      _ref.read(selectedAddressProvider.notifier).state = null;
      _ref.read(guestAddressProvider.notifier).state = null;

      print('Address data cleared');
    } catch (e) {
      print('Error clearing address data: $e');
    }
  }

  // Helper method to clear cart and wishlist
  void _clearCartAndWishlist() {
    try {
      // Clear cart
      _ref.read(cartProvider.notifier).state = [];

      // Clear wishlist
      _ref.read(wishlistProvider.notifier).state = [];

      // Reset cart tab index
      _ref.read(cartTabIndexProvider.notifier).state = 0;

      print('Cart and wishlist cleared');
    } catch (e) {
      print('Error clearing cart and wishlist: $e');
    }
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _ref.read(_isLoggedInProvider);
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _ref.read(_authUserIdProvider);
  }

  // Get current user model
  UserModel? getCurrentUser() {
    return _ref.read(_userProvider);
  }

  // Reset checkout session
  void resetCheckoutSession() {
    try {
      // ADDED: Clear address data first
      _clearAddressData();

      // Get the current user ID if logged in
      final userId = _ref.read(_authUserIdProvider);
      final isLoggedIn = _ref.read(_isLoggedInProvider);

      // Clear the existing session
      _sessionManager.clearCheckoutSession();

      // If logged in, create a new session with the user ID
      if (isLoggedIn && userId != null) {
        _sessionManager.initializeCheckoutSession(
          userId: userId,
          isGuestCheckout: false,
        );
      } else {
        // Otherwise create a guest session
        _sessionManager.initializeCheckoutSession(
          isGuestCheckout: true,
        );
      }

      // ADDED: Reset cart tab index
      _ref.read(cartTabIndexProvider.notifier).state = 0;

      // ADDED: Reset shipping cost if provider exists
      try {
        if (_ref.exists(shippingCostProvider)) {
          _ref.read(shippingCostProvider.notifier).state = 0.0;
        }
      } catch (e) {
        print('Error resetting shipping cost: $e');
      }

      print('Checkout session reset');
    } catch (e) {
      print('Error resetting checkout session: $e');
    }
  }
}

// Provider for the auth service
final authServiceProvider = riverpod.Provider<AuthService>((ref) {
  final supabase = Supabase.instance.client;
  final userService = ref.watch(userServiceProvider);
  final sessionManager = ref.watch(checkoutSessionManagerProvider);

  return AuthService(supabase, ref, userService, sessionManager);
});

// Provider for user service
final userServiceProvider = riverpod.Provider<UserService>((ref) {
  return UserService();
});

// ADDED: Define shipping cost provider if it doesn't exist elsewhere
final shippingCostProvider = riverpod.StateProvider<double>((ref) => 0.0);

