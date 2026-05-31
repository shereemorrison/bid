
import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/components/product_widgets/product_list_row.dart';
import 'package:bid/state/cart/cart_state.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:bid/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    final quantity = cartItem.quantity > 0 ? cartItem.quantity : 1;
    final size = cartItem.selectedSize;

    return ProductListRow(
      image: buildProductImage(context, product.imageUrl, product.imagePath),
      name: product.name,
      priceText: formatPrice(product.price),
      attributeTags: [
        buildAttributeTag('Size: $size', context),
        const SizedBox(width: 8),
        buildAttributeTag('Qty: $quantity', context),
      ],
      trailing: CustomIconButton(
        icon: Icons.close,
        onTap: onRemove,
        size: 30,
        iconSize: 20,
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        iconColor: Theme.of(context).colorScheme.textSecondary,
      ),
    );
  }
}
