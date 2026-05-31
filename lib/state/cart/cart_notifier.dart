import 'package:bid/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../base/base_notifier.dart';
import 'cart_state.dart';

class CartNotifier extends BaseNotifier<CartState> {
  static const _guestCartKey = 'cart_guest';

  CartNotifier() : super(CartState.initial()) {
    _loadCart();
  }

  int _loadGeneration = 0;

  String? _getCurrentUserId() {
    return Supabase.instance.client.auth.currentUser?.id;
  }

  String _cartStorageKey(String? userId) {
    return userId != null ? 'cart_$userId' : _guestCartKey;
  }

  Future<void> _loadCart() async {
    final generation = ++_loadGeneration;
    startLoading();

    try {
      final userId = _getCurrentUserId();
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartStorageKey(userId));

      if (generation != _loadGeneration) return;

      if (cartJson != null) {
        final cartData = jsonDecode(cartJson) as List;
        final items =
            cartData.map((item) => CartItem.fromJson(item)).toList();
        state = state.copyWith(items: items, clearError: true);
      } else {
        state = state.copyWith(items: [], clearError: true);
      }

      endLoading();
    } catch (e) {
      if (generation != _loadGeneration) return;
      handleError('loading cart', e);
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartKey = _cartStorageKey(_getCurrentUserId());
      final cartJson =
          jsonEncode(state.items.map((item) => item.toJson()).toList());
      await prefs.setString(cartKey, cartJson);
    } catch (e) {
      handleError('saving cart', e);
    }
  }

  void addToCart(Product product, {int quantity = 1, Map<String, dynamic>? options}) {
    final existingIndex = state.items.indexWhere((item) =>
        item.productId == product.id && _optionsMatch(item.options, options));

    if (existingIndex >= 0) {
      final existingItem = state.items[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        productRef: product,
      );

      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItem;
      state = state.copyWith(items: updatedItems);
    } else {
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
    final updatedItems =
        state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
    _saveCart();
  }

  void clearCart() {
    state = state.copyWith(items: []);
    _saveCart();
  }

  /// Clears cart memory and storage when the user signs out.
  Future<void> resetOnSignOut() async {
    _loadGeneration++;
    final userId = _getCurrentUserId();

    state = CartState.initial();

    try {
      final prefs = await SharedPreferences.getInstance();
      if (userId != null) {
        await prefs.remove('cart_$userId');
      }
      await prefs.remove(_guestCartKey);
    } catch (e) {
      handleError('resetting cart on sign out', e);
    }
  }

  bool _optionsMatch(
    Map<String, dynamic>? options1,
    Map<String, dynamic>? options2,
  ) {
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

  /// Keeps in-memory / guest-cart items when the user signs in during checkout.
  Future<void> mergeGuestCartOnSignIn() async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final generation = _loadGeneration;

    final inMemoryItems = List<CartItem>.from(state.items);
    final prefs = await SharedPreferences.getInstance();
    final guestJson = prefs.getString(_guestCartKey);
    final userJson = prefs.getString('cart_$userId');

    List<CartItem> merged = [];

    if (userJson != null) {
      merged = (jsonDecode(userJson) as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
    }

    if (guestJson != null) {
      final guestItems = (jsonDecode(guestJson) as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
      merged = _mergeItemLists(merged, guestItems);
    }

    if (inMemoryItems.isNotEmpty) {
      merged = _mergeItemLists(merged, inMemoryItems);
    }

    if (generation != _loadGeneration) return;

    state = state.copyWith(items: merged, clearError: true);
    await prefs.setString('cart_$userId',
        jsonEncode(merged.map((item) => item.toJson()).toList()));
    await prefs.remove(_guestCartKey);
  }

  List<CartItem> _mergeItemLists(List<CartItem> base, List<CartItem> incoming) {
    final merged = List<CartItem>.from(base);

    for (final item in incoming) {
      final index = merged.indexWhere(
        (existing) =>
            existing.productId == item.productId &&
            _optionsMatch(existing.options, item.options),
      );

      if (index >= 0) {
        merged[index] = merged[index].copyWith(
          quantity: merged[index].quantity + item.quantity,
        );
      } else {
        merged.add(item);
      }
    }

    return merged;
  }

  Future<void> refreshCart() async {
    await _loadCart();
  }
}
