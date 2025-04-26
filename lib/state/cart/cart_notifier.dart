import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../base/base_notifier.dart';
import 'cart_state.dart';

class CartNotifier extends BaseNotifier<CartState> {
  final Ref _ref;

  CartNotifier(this._ref) : super(CartState.initial()) {
    // Load cart from local storage on initialisation
    _loadCart();
  }

  String _getCurrentUserId() {
    // Get current user ID from Supabase, or use the guest ID if not logged in
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      return currentUser.id;
    }

    // Use the guest user ID from the provider
    try {
      final guestUserId = _ref.read(guestUserIdProvider);
      return guestUserId;
    } catch (e) {
      print('Error reading guest user ID: $e');
      return 'guest';
    }
  }

  Future<void> _loadCart() async {
    startLoading();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _getCurrentUserId();
      final cartKey = 'cart_$userId';

      print('Loading cart for user: $userId with key: $cartKey');

      final cartJson = prefs.getString('cart');

      if (cartJson != null) {
        final cartData = jsonDecode(cartJson) as List;
        final items = cartData.map((item) => CartItem.fromJson(item)).toList();

        state = state.copyWith(
          items: items,
          clearError: true,
        );
        endLoading();
      } else {
        state = state.copyWith(
          items: [],
          clearError: true,
        );
        endLoading();
      }
    } catch (e) {
      handleError('loading cart', e);
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _getCurrentUserId();
      final cartKey = 'cart_$userId';

      print('Saving cart for user: $userId with key: $cartKey');

      final cartJson = jsonEncode(state.items.map((item) => item.toJson()).toList());
      await prefs.setString('cart', cartJson);
    } catch (e) {
      handleError('saving cart', e);
    }
  }

  void addToCart(Product product, {int quantity = 1, Map<String, dynamic>? options}) {
    // Check if product already exists in cart
    final existingIndex = state.items.indexWhere((item) =>
    item.productId == product.id &&
        _optionsMatch(item.options, options));

    if (existingIndex >= 0) {
      // Update quantity of existing item
      final existingItem = state.items[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        productRef: product, // Update the product reference
      );

      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItem;

      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      final newItem = CartItem.fromProduct(
        product,
        quantity: quantity,
        options: options,
      );

      state = state.copyWith(items: [...state.items, newItem]);
    }

    _saveCart();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    _saveCart();
  }

  void removeFromCart(String itemId) {
    final updatedItems = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
    _saveCart();
  }

  void clearCart() {
    state = state.copyWith(items: []);
    _saveCart();
  }

  bool _optionsMatch(Map<String, dynamic>? options1, Map<String, dynamic>? options2) {
    if (options1 == null && options2 == null) return true;
    if (options1 == null || options2 == null) return false;

    if (options1.length != options2.length) return false;

    for (final key in options1.keys) {
      if (!options2.containsKey(key) || options1[key] != options2[key]) {
        return false;
      }
    }

    return true;
  }

  Future<void> refreshCart() async {
    await _loadCart();
  }
}
