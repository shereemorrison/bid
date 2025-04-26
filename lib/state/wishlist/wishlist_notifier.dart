import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../base/base_notifier.dart';
import 'wishlist_state.dart';

class WishlistNotifier extends BaseNotifier<WishlistState> {
  WishlistNotifier() : super(WishlistState.initial()) {
    // Load wishlist from local storage on initialization
    _loadWishlist();
  }

  String _getCurrentUserId() {
    // Get the current user ID from Supabase, or use 'guest' if not logged in
    final currentUser = Supabase.instance.client.auth.currentUser;
    return currentUser?.id ?? 'guest';
  }

  Future<void> _loadWishlist() async {
    startLoading();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _getCurrentUserId();
      final wishlistKey = 'wishlist_$userId';

      print('Loading wishlist for user: $userId with key: $wishlistKey');
      final wishlistJson = prefs.getString(wishlistKey);

      if (wishlistJson != null) {
        final wishlistData = jsonDecode(wishlistJson) as List;
        final productIds = wishlistData.map((item) => item.toString()).toList();

        state = state.copyWith(
          productIds: productIds.cast<String>(),
          clearError: true,
        );
        endLoading();
      } else {
        state = state.copyWith(
          productIds: [],
          clearError: true,
        );
        endLoading();
      }
    } catch (e) {
      handleError('loading wishlist', e);
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _getCurrentUserId();
      final wishlistKey = 'wishlist_$userId';
      final wishlistJson = jsonEncode(state.productIds);
      await prefs.setString(wishlistKey, wishlistJson);
    } catch (e) {
      handleError('saving wishlist', e);
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

  Future<void> refreshWishlist() async {
    await _loadWishlist();
  }
}
