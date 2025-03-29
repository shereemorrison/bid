import 'package:bid/models/products_model.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dialog_service.dart';

class CartService {
  // Add item to cart
  void addToCart(BuildContext context, Product product) {
    context.read<Shop>().addToCart(product);
    DialogService.showAddToCartDialog(context, product);
  }

  // Remove item from cart
  void removeFromCart(BuildContext context, Product product) {
    context.read<Shop>().removeFromCart(product);
    DialogService.showRemoveFromCartDialog(context, product);
  }
}