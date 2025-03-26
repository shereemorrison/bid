import 'package:flutter/material.dart';
import 'package:bid/services/cart_service.dart';
import 'package:bid/models/products_model.dart';

import '../buttons/shopping_buttons.dart';

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
    final customBeige = Theme.of(context).colorScheme.secondary;
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final textColor = isLightMode ? Colors.black : customBeige;
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

