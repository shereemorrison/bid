
import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void addToCartWithFeedback(
    BuildContext context,
    WidgetRef ref,
    Product product, {
      int quantity = 1,
      String? size,
    }) {
  // Add to cart
  ref.read(cartProvider.notifier).addToCart(
    product,
    quantity: quantity,
    options: size != null ? {'size': size} : null,
  );

  // Show dialog
  DialogService.showAddToCartDialog(context, product);
}