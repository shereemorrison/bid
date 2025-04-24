import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'wishlist_state.dart';

class WishlistNotifier extends StateNotifier<WishlistState> {
  WishlistNotifier() : super(WishlistState.initial()) {
    // Load wishlist from local storage on initialization
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = prefs.getString('wishlist');

      if (wishlistJson != null) {
        final wishlistData = jsonDecode(wishlistJson) as List;
        final productIds = wishlistData.map((item) => item.toString()).toList();

        state = state.copyWith(
          productIds: productIds.cast<String>(),
          isLoading: false,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          productIds: [],
          isLoading: false,
          clearError: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load wishlist: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = jsonEncode(state.productIds);
      await prefs.setString('wishlist', wishlistJson);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to save wishlist: $e',
      );
    }
  }

  void addToWishlist(String productId) {
    if (!state.productIds.contains(productId)) {
      state = state.copyWith(
        productIds: [...state.productIds, productId],
      );
      _saveWishlist();
    }
  }

  void removeFromWishlist(String productId) {
    state = state.copyWith(
      productIds: state.productIds.where((id) => id != productId).toList(),
    );
    _saveWishlist();
  }

  void toggleWishlist(String productId) {
    if (state.productIds.contains(productId)) {
      removeFromWishlist(productId);
    } else {
      addToWishlist(productId);
    }
  }

  void clearWishlist() {
    state = state.copyWith(productIds: []);
    _saveWishlist();
  }

  bool isInWishlist(String productId) {
    return state.productIds.contains(productId);
  }
}
