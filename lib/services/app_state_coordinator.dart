import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class AppStateCoordinator {
  final Ref _ref;

  AppStateCoordinator(this._ref);

  // Reset all app state
  Future<void> resetAppState() async {
    // Clear cart
    _ref.read(cartProvider.notifier).clearCart();

    // Reset checkout
    _ref.read(checkoutProvider.notifier).reset();

    // Clear addresses
    _ref.read(addressProvider.notifier).clearAddresses();

    // Clear orders
    _ref.read(ordersProvider.notifier).clearOrders();

    // Clear wishlist
    _ref.read(wishlistProvider.notifier).clearWishlist();
  }

  // Handle user sign in
  Future<void> handleUserSignIn(String userId) async {
    // Refresh cart
    await _ref.read(cartProvider.notifier).refreshCart();

    // Refresh wishlist
    await _ref.read(wishlistProvider.notifier).refreshWishlist();

    // Load addresses
    await _ref.read(addressProvider.notifier).fetchUserAddresses(userId);

    // Load orders
    await _ref.read(ordersProvider.notifier).fetchUserOrders(userId);
  }

  // Handle user sign out
  Future<void> handleUserSignOut() async {
    await resetAppState();
  }

  // Handle checkout completion
  Future<void> handleCheckoutComplete() async {
    // Clear cart
    _ref.read(cartProvider.notifier).clearCart();

    // Reset checkout
    _ref.read(checkoutProvider.notifier).reset();
  }
}
