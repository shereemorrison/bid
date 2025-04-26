import 'package:bid/respositories/address_repository.dart';
import 'package:bid/respositories/category_repository.dart';
import 'package:bid/respositories/order_repository.dart' as repo;
import 'package:bid/respositories/payment_repository.dart';
import 'package:bid/respositories/product_repository.dart';
import 'package:bid/respositories/user_repository.dart';
import 'package:bid/services/app_state_coordinator.dart';
import 'package:bid/services/database_diagnostic.dart';
import 'package:bid/services/guest_order_service.dart';
import 'package:bid/services/mapbox_service.dart';
import 'package:bid/services/payment_service.dart';
import 'package:bid/state/theme/theme_notifier.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:flutter/material.dart';
// Use an alias for Riverpod to avoid conflicts with Supabase's Provider
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:uuid/uuid.dart';

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
import 'models/category_model.dart' as app_category;
import 'models/order_model.dart';
import 'models/address_model.dart';
import 'models/payment_method_model.dart';

// Change the guestUserIdProvider to not include the "guest-" prefix
final guestUserIdProvider = riverpod.StateProvider<String>((ref) {
  return const Uuid().v4();  // Initialize with a valid UUID by default
});

// Function to initialize or retrieve the guest user ID
Future<String> initializeGuestUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String guestUserId = prefs.getString('guest_user_id') ?? '';

  if (guestUserId.isEmpty) {
    // Generate a new UUID for the guest user (without prefix)
    guestUserId = const Uuid().v4();
    await prefs.setString('guest_user_id', guestUserId);
    print('Created new guest user ID: $guestUserId');
  } else {
    print('Using existing guest user ID: $guestUserId');
  }

  return guestUserId;
}

// Supabase client provider
final supabaseClientProvider = riverpod.Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Database diagnostic provider
final databaseDiagnosticProvider = riverpod.Provider<DatabaseDiagnostic>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DatabaseDiagnostic(client);
});

// App State Coordinator provider
final appStateCoordinatorProvider = riverpod.Provider<AppStateCoordinator>((ref) {
  return AppStateCoordinator(ref);
});

// Payment Service provider
final paymentServiceProvider = riverpod.Provider<PaymentService>((ref) {
  return PaymentService(ref);
});

// Mapbox Service provider
final mapboxServiceProvider = riverpod.Provider<MapboxService>((ref) {
  // Replace with your actual Mapbox API key
  const apiKey = 'your_mapbox_api_key';
  return MapboxService(apiKey: apiKey);
});

// Guest Order Service provider
final guestOrderServiceProvider = riverpod.Provider<GuestOrderService>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final addressRepository = ref.watch(addressRepositoryProvider);
  final orderRepository = ref.watch(orderRepositoryProvider);

  return GuestOrderService(
    userRepository: userRepository,
    addressRepository: addressRepository,
    orderRepository: orderRepository,
  );
});

// Repository Providers
final userRepositoryProvider = riverpod.Provider<UserRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return UserRepository(client: client);
});

final orderRepositoryProvider = riverpod.Provider<repo.OrderRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return repo.OrderRepository(client: client);
});

final addressRepositoryProvider = riverpod.Provider<AddressRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AddressRepository(client: client);
});

final paymentRepositoryProvider = riverpod.Provider<PaymentRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PaymentRepository(client: client);
});

final categoryRepositoryProvider = riverpod.Provider<CategoryRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CategoryRepository(client: client);
});

final productRepositoryProvider = riverpod.Provider<ProductRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProductRepository(client: client);
});

// Theme notifier provider
final themeNotifierProvider = riverpod.StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

// Provider to easily access isDarkMode state
final isDarkModeProvider = riverpod.Provider<bool>((ref) {
  return ref.watch(themeNotifierProvider).isDarkMode;
});

// Provider for the current ThemeData
final themeProvider = riverpod.Provider<ThemeData>((ref) {
  final isDarkMode = ref.watch(isDarkModeProvider);
  return isDarkMode ? darkMode : lightMode;
});

// Main state notifier providers
final authProvider = riverpod.StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    userRepository: ref.watch(userRepositoryProvider),
    ref: ref,
    stateCoordinator: ref.watch(appStateCoordinatorProvider),
  );
});

final cartProvider = riverpod.StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref);
});

final wishlistProvider = riverpod.StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier();
});

final checkoutProvider = riverpod.StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(
    orderRepository: ref.watch(orderRepositoryProvider),
    guestOrderService: ref.watch(guestOrderServiceProvider),
  );
});

final ordersProvider = riverpod.StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(
    orderRepository: ref.watch(orderRepositoryProvider),
    ref: ref,
  );
});

final addressProvider = riverpod.StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(addressRepository: ref.watch(addressRepositoryProvider));
});

final productsProvider = riverpod.StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(
    productRepository: ref.watch(productRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
  );
});

// Convenience Providers for common state access

// Auth convenience providers
final isLoggedInProvider = riverpod.Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

// Update the userIdProvider to handle guest users correctly
final userIdProvider = riverpod.Provider<String>((ref) {
  // Return the authenticated user ID if logged in, otherwise return the guest user ID
  final authState = ref.watch(authProvider);
  if (authState.isLoggedIn && authState.userId != null) {
    return authState.userId!;
  }

  // For guest users, use the UUID from guestUserIdProvider
  final guestId = ref.watch(guestUserIdProvider);
  print('Using guest user ID: $guestId');
  return guestId;
});

final userDataProvider = riverpod.Provider<UserData?>((ref) {
  return ref.watch(authProvider).userData;
});

final authLoadingProvider = riverpod.Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = riverpod.Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

// Address convenience providers
final userAddressesProvider = riverpod.Provider<List<Address>>((ref) {
  return ref.watch(addressProvider).addresses;
});

final selectedAddressProvider = riverpod.Provider<Address?>((ref) {
  return ref.watch(addressProvider).selectedAddress;
});

final effectiveAddressProvider = riverpod.Provider<Address?>((ref) {
  return ref.watch(selectedAddressProvider);
});

// Cart convenience providers
final cartItemsProvider = riverpod.Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider).items;
});

final cartSubtotalProvider = riverpod.Provider<double>((ref) {
  return ref.watch(cartProvider).subtotal;
});

final cartItemCountProvider = riverpod.Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartLoadingProvider = riverpod.Provider<bool>((ref) {
  return ref.watch(cartProvider).isLoading;
});

final cartErrorProvider = riverpod.Provider<String?>((ref) {
  return ref.watch(cartProvider).error;
});

// Wishlist convenience providers
final isInWishlistProvider = riverpod.Provider.family<bool, String>((ref, productId) {
  return ref.watch(wishlistProvider).productIds.contains(productId);
});

// Checkout convenience providers
final checkoutStepProvider = riverpod.Provider<CheckoutStep>((ref) {
  return ref.watch(checkoutProvider).currentStep;
});

final checkoutCompleteProvider = riverpod.StateProvider<bool>((ref) {
  return false;
});

// Products convenience providers
final categoriesProvider = riverpod.Provider<List<app_category.Category>>((ref) {
  return ref.watch(productsProvider).categories;
});

final allProductsProvider = riverpod.Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).products;
});

final selectedCategoryProvider = riverpod.Provider<app_category.Category?>((ref) {
  return ref.watch(productsProvider).selectedCategory;
});

final productsLoadingProvider = riverpod.Provider<bool>((ref) {
  return ref.watch(productsProvider).isLoading;
});

final productsErrorProvider = riverpod.Provider<String?>((ref) {
  return ref.watch(productsProvider).error;
});

// Orders convenience providers
final userOrdersProvider = riverpod.Provider<List<Order>>((ref) {
  return ref.watch(ordersProvider).orders;
});

final selectedOrderProvider = riverpod.Provider<Order?>((ref) {
  return ref.watch(ordersProvider).selectedOrder;
});

final ordersLoadingProvider = riverpod.Provider<bool>((ref) {
  return ref.watch(ordersProvider).isLoading;
});

final ordersErrorProvider = riverpod.Provider<String?>((ref) {
  return ref.watch(ordersProvider).error;
});

// Wishlist convenience providers
final wishlistItemsProvider = riverpod.Provider<List<String>>((ref) {
  return ref.watch(wishlistProvider).productIds;
});
