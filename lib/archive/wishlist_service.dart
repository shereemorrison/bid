// import 'package:bid/models/products_model.dart';
// import 'package:bid/providers/shop_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dialog_service.dart';
// import 'cart_service.dart';
//
// class WishlistService {
//   final CartService _cartService = CartService();
//
//   // Add item to wishlist
//   void addToWishlist(BuildContext context, Product product, WidgetRef ref) {
//     ref.read(shopNotifierProvider.notifier).addToWishlist(product);
//     DialogService.showAddToWishlistDialog(context, product);
//   }
//
//   // Remove item from wishlist
//   void removeFromWishlist(BuildContext context, Product product, WidgetRef ref) {
//     ref.read(shopNotifierProvider.notifier).removeFromWishlist(product.id);
//     DialogService.showRemoveFromWishlistDialog(context, product);
//   }
//
//   // Add item from wishlist to cart
//   void addToCart(BuildContext context, Product product, WidgetRef ref) {
//     _cartService.addToCart(context, product, ref);
//   }
// }