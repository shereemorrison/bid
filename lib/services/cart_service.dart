
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/shop_provider.dart';

import '../models/products_model.dart';

class CartService {
  void removeFromCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        content: const Text(
          "Remove this from your cart?",
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
              context.read<Shop>().removeFromCart(product);
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
}