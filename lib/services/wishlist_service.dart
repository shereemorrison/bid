
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/shop_provider.dart';

import '../models/products_model.dart';

class WishlistService {
  void removeFromWishlist(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        content: const Text(
          "Remove this from your wishlist?",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().removeFromWishlist(product);
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(BuildContext context, Product product) {
    context.read<Shop>().addToCart(product);
    _showAlertDialog(context, "${product.name} added to cart");
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
    );
  }
}

