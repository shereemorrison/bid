
import 'package:bid/models/products_model.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopService {
  // Cart operations
  void addToCart(BuildContext context, Product product, WidgetRef ref) {
    ref.read(shopNotifierProvider.notifier).addToCart(product);
    DialogService.showAddToCartDialog(context, product);
  }

  void removeFromCart(BuildContext context, Product product, WidgetRef ref) {
    ref.read(shopNotifierProvider.notifier).removeFromCart(product.id);
    DialogService.showRemoveFromCartDialog(context, product);
  }

  // Wishlist operations
  void addToWishlist(BuildContext context, Product product, WidgetRef ref) {
    ref.read(shopNotifierProvider.notifier).addToWishlist(product);
    DialogService.showAddToWishlistDialog(context, product);
  }

  void removeFromWishlist(BuildContext context, Product product, WidgetRef ref) {
    ref.read(shopNotifierProvider.notifier).removeFromWishlist(product.id);
    DialogService.showRemoveFromWishlistDialog(context, product);
  }
}

final shopServiceProvider = Provider<ShopService>((ref) => ShopService());