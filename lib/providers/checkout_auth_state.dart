import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for tracking the current state of the checkout authentication flow
enum CheckoutAuthState {
  options,      // Showing login/register/guest options
  login,        // Showing login form
  register,     // Showing registration form
  guestCheckout, // Proceeding as guest
  createAccountFromGuest, // Creating account from guest checkout
  completed     // Authentication completed
}

// Provider for the current checkout auth state
final checkoutAuthStateProvider = StateProvider<CheckoutAuthState>((ref) =>
CheckoutAuthState.options);
