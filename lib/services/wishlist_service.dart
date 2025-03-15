import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import '../providers/shop_provider.dart';
import 'dialog_service.dart';
import 'cart_service.dart';

class WishlistService {
  final CartService _cartService = CartService();

  // Add item to wishlist
  void addToWishlist(BuildContext context, Product product) {
    context.read<Shop>().addToWishlist(product);
    DialogService.showAddToWishlistDialog(context, product);
  }

  // Remove item from wishlist
  void removeFromWishlist(BuildContext context, Product product) {
    context.read<Shop>().removeFromWishlist(product);
    DialogService.showRemoveFromWishlistDialog(context, product);
  }

  // Add item from wishlist to cart
  void addToCart(BuildContext context, Product product) {
    _cartService.addToCart(context, product);
  }
}