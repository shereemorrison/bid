import 'package:bid/state/wishlist/wishlist_notifier.dart';
import 'package:bid/state/wishlist/wishlist_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier();
});

final wishlistItemsProvider = Provider<List<String>>((ref) {
  return ref.watch(wishlistProvider).productIds;
});

final isInWishlistProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(wishlistProvider).productIds.contains(productId);
});
