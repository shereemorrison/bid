import 'package:bid/state/cart/cart_notifier.dart';
import 'package:bid/state/cart/cart_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider).items;
});
