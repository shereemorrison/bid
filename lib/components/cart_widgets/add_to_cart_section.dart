import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/services/cart_service.dart';
import 'package:bid/models/products_model.dart';


class AddToCartSection extends StatelessWidget {
  final Product product;
  final int quantity;

  const AddToCartSection({
    Key? key,
    required this.product,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.accent;
    final cartService = CartService();

    return AddToCartButton(
      onTap: () {
        cartService.addToCart(context, product);
      },
      width: double.infinity,
      textColor: textColor,
      borderColor: textColor,
    );
  }
}

