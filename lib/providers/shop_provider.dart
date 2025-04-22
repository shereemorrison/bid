// lib/providers/shop_provider.dart
import 'package:bid/services/dialog_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/products_model.dart';

// State providers
final cartTabIndexProvider = StateProvider<int>((ref) => 0);
final cartProvider = StateProvider<List<Product>>((ref) => []);
final shopLoadingProvider = StateProvider<bool>((ref) => false);
final shopErrorProvider = StateProvider<String?>((ref) => null);

// Controller notifier for complex state management
class ShopNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ShopNotifier(this._ref) : super(const AsyncValue.data(null));

  // Add product to cart
  void addToCart(Product product) {
    final currentCart = List<Product>.from(_ref.read(cartProvider));
    currentCart.add(product);
    _ref.read(cartProvider.notifier).state = currentCart;
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    final currentCart = List<Product>.from(_ref.read(cartProvider));
    final updatedCart = currentCart.where((item) => item.id != productId).toList();
    _ref.read(cartProvider.notifier).state = updatedCart;
  }

  // Clear cart
  void clearCart() {
    _ref.read(cartProvider.notifier).state = [];
  }

  // Update product quantity
  void updateQuantity(String productId, int quantity) {
    final currentCart = List<Product>.from(_ref.read(cartProvider));
    final updatedCart = currentCart.map((item) {
      if (item.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    _ref.read(cartProvider.notifier).state = updatedCart;
  }

  // Add product to wishlist
  void addToWishlist(Product product) {
    final currentWishlist = List<Product>.from(_ref.read(wishlistProvider));
    // Check if product is already in wishlist
    if (!currentWishlist.any((item) => item.id == product.id)) {
      currentWishlist.add(product);
      _ref.read(wishlistProvider.notifier).state = currentWishlist;
    }
  }

  // Remove product from wishlist
  void removeFromWishlist(String productId) {
    final currentWishlist = List<Product>.from(_ref.read(wishlistProvider));
    final updatedWishlist = currentWishlist.where((item) => item.id != productId).toList();
    _ref.read(wishlistProvider.notifier).state = updatedWishlist;
  }

  // Clear wishlist
  void clearWishlist() {
    _ref.read(wishlistProvider.notifier).state = [];
  }

  void addToCartWithFeedback(BuildContext context, Product product) {
    addToCart(product);
    DialogService.showAddToCartDialog(context, product);
  }

  void removeFromCartWithFeedback(BuildContext context, String productId, Product product) {
    removeFromCart(productId);
    DialogService.showRemoveFromCartDialog(context, product);
  }
}

// Provider for the shop notifier
final shopNotifierProvider = StateNotifierProvider<ShopNotifier, AsyncValue<void>>((ref) {
  return ShopNotifier(ref);
});

final wishlistProvider = StateProvider<List<Product>>((ref) => []);

final shopProvider = Provider<Shop>((ref) {
  final cartItems = ref.watch(cartProvider);
  final wishlistItems = ref.watch(wishlistProvider);
  final shopNotifier = ref.watch(shopNotifierProvider.notifier);

  return Shop(
    cart: cartItems,
    wishlist: wishlistItems,
    addToCart: shopNotifier.addToCart,
    removeFromCart: shopNotifier.removeFromCart,
    clearCart: shopNotifier.clearCart,
    updateQuantity: shopNotifier.updateQuantity,
    addToWishlist: shopNotifier.addToWishlist,
    removeFromWishlist: shopNotifier.removeFromWishlist,
    clearWishlist: shopNotifier.clearWishlist,
    addToCartWithFeedback: shopNotifier.addToCartWithFeedback,
    removeFromCartWithFeedback: shopNotifier.removeFromCartWithFeedback,

    setCartTabIndex: (index) => ref.read(cartTabIndexProvider.notifier).state = index,

    addToWishlistWithFeedback: (context, product) {
      shopNotifier.addToWishlist(product);
      DialogService.showAddToWishlistDialog(context, product);
    },
    removeFromWishlistWithFeedback: (context, productId, product) {
      shopNotifier.removeFromWishlist(productId);
      DialogService.showRemoveFromWishlistDialog(context, product);
    },
  );
});

class Shop {
  final List<Product> cart;
  final List<Product> wishlist;
  final Function(Product) addToCart;
  final Function(String) removeFromCart;
  final Function() clearCart;
  final Function(String, int) updateQuantity;
  final Function(Product) addToWishlist;
  final Function(String) removeFromWishlist;
  final Function() clearWishlist;
  final Function(BuildContext, Product) addToCartWithFeedback;
  final Function(BuildContext, String, Product) removeFromCartWithFeedback;
  final Function(BuildContext, Product) addToWishlistWithFeedback;
  final Function(BuildContext, String, Product) removeFromWishlistWithFeedback;
  final Function(int) setCartTabIndex;

  Shop({
    required this.cart,
    required this.wishlist,
    required this.addToCart,
    required this.removeFromCart,
    required this.clearCart,
    required this.updateQuantity,
    required this.addToWishlist,
    required this.removeFromWishlist,
    required this.clearWishlist,
    required this.addToCartWithFeedback,
    required this.removeFromCartWithFeedback,
    required this.addToWishlistWithFeedback,
    required this.removeFromWishlistWithFeedback,
    required this.setCartTabIndex,

  });
}