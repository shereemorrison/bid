import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/checkout_session_data.dart';
import '../providers/address_provider.dart';

class CheckoutSessionManager {
  final Ref _ref;
  final uuid = const Uuid();

  CheckoutSessionManager(this._ref);

  // Initialize a new checkout session
  void initializeCheckoutSession({
    String? userId,
    bool isGuestCheckout = true,
    Map<String, dynamic>? shippingAddress,
  }) {
    final sessionId = uuid.v4();

    final session = CheckoutSessionData(
      sessionId: sessionId,
      userId: userId,
      isGuestCheckout: isGuestCheckout,
      shippingAddress: shippingAddress ?? {},
      createdAt: DateTime.now(),
    );

    _ref.read(checkoutSessionProvider.notifier).state = session;
    print('New checkout session initialized: $sessionId');
  }

  // Get the current checkout session
  CheckoutSessionData? getCurrentSession() {
    return _ref.read(checkoutSessionProvider);
  }

  // Update the shipping address in the current session
  void updateShippingAddress(Map<String, dynamic> shippingAddress) {
    final currentSession = _ref.read(checkoutSessionProvider);
    if (currentSession != null) {
      _ref.read(checkoutSessionProvider.notifier).state =
          currentSession.copyWith(shippingAddress: shippingAddress);
    }
  }

  // Update the user ID in the current session
  void updateSessionUser(String userId) {
    final currentSession = _ref.read(checkoutSessionProvider);
    if (currentSession != null) {
      _ref.read(checkoutSessionProvider.notifier).state =
          currentSession.copyWith(
            userId: userId,
            isGuestCheckout: false,
          );
      print('Updated session user ID: $userId');
    }
  }

  // Clear the current checkout session
  void clearCheckoutSession() {
    _ref.read(checkoutSessionProvider.notifier).state = null;

    // Also clear the address providers
    try {
      // FIXED: Don't try to set state on effectiveAddressProvider (it's a computed provider)
      // Instead, clear the source providers that effectiveAddressProvider depends on
      _ref.read(selectedAddressProvider.notifier).state = null;
      _ref.read(guestAddressProvider.notifier).state = null;

      // ADDED: Reset shipping cost if provider exists
      if (_ref.exists(shippingCostProvider)) {
        _ref.read(shippingCostProvider.notifier).state = 0.0;
      }
    } catch (e) {
      print('Error clearing address data: $e');
    }

    print('Checkout session cleared');
  }

  // Check if the current session is a guest checkout
  bool isGuestCheckout() {
    final currentSession = _ref.read(checkoutSessionProvider);
    return currentSession?.isGuestCheckout ?? true;
  }

  // Get the shipping address from the current session
  Map<String, dynamic>? getShippingAddress() {
    final currentSession = _ref.read(checkoutSessionProvider);
    return currentSession?.shippingAddress;
  }

  // Get the user ID from the current session
  String? getUserId() {
    final currentSession = _ref.read(checkoutSessionProvider);
    return currentSession?.userId;
  }
}

// Provider for the checkout session manager
final checkoutSessionManagerProvider = Provider<CheckoutSessionManager>((ref) {
  return CheckoutSessionManager(ref);
});

// ADDED: Define shipping cost provider if it doesn't exist elsewhere
final shippingCostProvider = StateProvider<double>((ref) => 0.0);
