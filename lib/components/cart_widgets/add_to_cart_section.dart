import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/services/shop_service.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/models/products_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddToCartSection extends ConsumerWidget {
  final Product product;
  final int quantity;
  final String? selectedSize;

  const AddToCartSection({
    Key? key,
    required this.product,
    required this.quantity,
    this.selectedSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).colorScheme.accent;
    final shopService = ShopService();

    return AddToCartButton(
      onTap: () {
        final productToAdd = product.copyWith(
          selectedSize: selectedSize,
          quantity: quantity,
        );

        shopService.addToCart(context, productToAdd, ref);
      },
      width: double.infinity,
      textColor: textColor,
      borderColor: textColor,
    );
  }
}

