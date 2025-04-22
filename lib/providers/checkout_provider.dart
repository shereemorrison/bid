import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define providers for checkout steps, shipping method, and payment method
final checkoutStepProvider = StateProvider<int>((ref) => 0); // Initial step is 0
final shippingMethodProvider = StateProvider<String?>((ref) => null);
final paymentMethodProvider = StateProvider<String?>((ref) => null);

// Create a provider class to manage checkout state and actions
class CheckoutProvider {
  final Ref _ref;

  CheckoutProvider(this._ref);

  void clearCheckoutData() {
    // Reset all checkout-related state
    _ref.read(checkoutStepProvider.notifier).state = 0; // Reset to first step
    _ref.read(shippingMethodProvider.notifier).state = null;
    _ref.read(paymentMethodProvider.notifier).state = null;
    // Add any other checkout-related state that needs clearing

    print('Checkout data cleared');
  }
}

// Create a provider instance of the CheckoutProvider class
final checkoutProvider = Provider((ref) => CheckoutProvider(ref));
