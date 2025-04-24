import 'package:bid/respositories/address_repository.dart';
import 'package:bid/respositories/category_repository.dart';
import 'package:bid/respositories/order_repository.dart' as repo;
import 'package:bid/respositories/payment_repository.dart';
import 'package:bid/respositories/product_repository.dart';
import 'package:bid/respositories/user_repository.dart';
import 'package:bid/state/theme/theme_notifier.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State Notifiers
import 'state/auth/auth_notifier.dart';
import 'state/auth/auth_state.dart';
import 'state/cart/cart_notifier.dart';
import 'state/cart/cart_state.dart';
import 'state/wishlist/wishlist_notifier.dart';
import 'state/wishlist/wishlist_state.dart';
import 'state/checkout/checkout_notifier.dart';
import 'state/checkout/checkout_state.dart';
import 'state/orders/orders_notifier.dart';
import 'state/orders/orders_state.dart';
import 'state/address/address_notifier.dart';
import 'state/address/address_state.dart';
import 'state/products/products_notifier.dart';
import 'state/products/products_state.dart';

// Models
import 'models/user_model.dart';
import 'models/product_model.dart';
import 'models/category_model.dart';
import 'models/order_model.dart';
import 'models/address_model.dart';
import 'models/payment_method_model.dart';

// Repository Providers
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final orderRepositoryProvider = Provider<repo.OrderRepository>((ref) {
  return repo.OrderRepository();
});

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Theme notifier provider
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

// Provider to easily access isDarkMode state
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeNotifierProvider).isDarkMode;
});

// Provider for the current ThemeData
final themeProvider = Provider<ThemeData>((ref) {
  final isDarkMode = ref.watch(isDarkModeProvider);
  return isDarkMode ? darkMode : lightMode;
});

// Main state notifier providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(userRepository: ref.watch(userRepositoryProvider));
});

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier();
});

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(orderRepository: ref.watch(orderRepositoryProvider));
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(orderRepository: ref.watch(orderRepositoryProvider));
});

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(addressRepository: ref.watch(addressRepositoryProvider));
});

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(
    productRepository: ref.watch(productRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
  );
});

// Convenience Providers for common state access

// Auth convenience providers
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final userIdProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).userId;
});

final userDataProvider = Provider<UserData?>((ref) {
  return ref.watch(authProvider).userData;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

// Address convenience providers
final userAddressesProvider = Provider<List<Address>>((ref) {
  return ref.watch(addressProvider).addresses;
});

final selectedAddressProvider = Provider<Address?>((ref) {
  return ref.watch(addressProvider).selectedAddress;
});

final effectiveAddressProvider = Provider<Address?>((ref) {
  return ref.watch(selectedAddressProvider);
});

// Cart convenience providers
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider).items;
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).subtotal;
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartLoadingProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isLoading;
});

final cartErrorProvider = Provider<String?>((ref) {
  return ref.watch(cartProvider).error;
});

// Wishlist convenience providers
final wishlistItemsProvider = Provider<List<String>>((ref) {
  return ref.watch(wishlistProvider).productIds;
});

final isInWishlistProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(wishlistProvider).productIds.contains(productId);
});

// Checkout convenience providers
final checkoutStepProvider = Provider<CheckoutStep>((ref) {
  return ref.watch(checkoutProvider).currentStep;
});

final checkoutItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(checkoutProvider).items;
});

final checkoutShippingAddressProvider = Provider<Address?>((ref) {
  return ref.watch(checkoutProvider).shippingAddress;
});

final checkoutPaymentMethodProvider = Provider<PaymentMethod?>((ref) {
  return ref.watch(checkoutProvider).paymentMethod;
});

final checkoutOrderIdProvider = Provider<String?>((ref) {
  return ref.watch(checkoutProvider).orderId;
});

final checkoutTotalProvider = Provider<double>((ref) {
  return ref.watch(checkoutProvider).total;
});

// Orders convenience providers
final userOrdersProvider = Provider<List<Order>>((ref) {
  return ref.watch(ordersProvider).orders;
});

final selectedOrderProvider = Provider<Order?>((ref) {
  return ref.watch(ordersProvider).selectedOrder;
});

final ordersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(ordersProvider).isLoading;
});

final ordersErrorProvider = Provider<String?>((ref) {
  return ref.watch(ordersProvider).error;
});

// Products convenience providers
final allProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).products;
});

final featuredProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).featuredProducts;
});

final mostWantedProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).mostWantedProducts;
});

final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(productsProvider).categories;
});

final selectedProductProvider = Provider<Product?>((ref) {
  return ref.watch(productsProvider).selectedProduct;
});

final selectedCategoryProvider = Provider<Category?>((ref) {
  return ref.watch(productsProvider).selectedCategory;
});

final productsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(productsProvider).isLoading;
});

final productsErrorProvider = Provider<String?>((ref) {
  return ref.watch(productsProvider).error;
});

// Checkout Auth State enum
enum CheckoutAuthState {
  options,
  login,
  register,
  createAccountFromGuest,
  guestCheckout,
  completed
}

enum CheckoutAuthOption {
  login,
  register,
  guest
}

// Checkout Auth State provider
final checkoutAuthStateProvider = StateProvider<CheckoutAuthState>((ref) {
  return CheckoutAuthState.options;
});
