
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/shop_provider.dart';

import '../models/products_model.dart';

class CartService {

  void addToCart(BuildContext context, Product product) {
    context.read<Shop>().addToCart(product);
    _showAlertDialog(context, "${product.name} added to cart");
  }

  void removeFromCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          "Remove this from your cart?",
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().removeFromCart(product);
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
    );
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


