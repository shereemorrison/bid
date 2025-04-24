
import 'package:bid/components/buttons/shopping_buttons.dart';
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Theme.of(context).colorScheme.cardBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: buildProductImage(context, product.imageUrl, product.imagePath),
              ),
            ),

            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),

                  //Price and quantity
                  Text(
                    '${formatPrice(product.price)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),
                  _buildProductAttributes(context),
                ],
              ),
            ),
            // Delete Button
            CustomIconButton(
              icon: Icons.close,
              onTap: onRemove,
              size: 30,
              iconSize: 20,
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              iconColor: Theme.of(context).colorScheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductAttributes(context) {
    int quantity = cartItem.quantity > 0 ? cartItem.quantity : 1;
    String? size = cartItem.selectedSize;

    return Row(
      children: [
        buildAttributeTag("Size: $size", context),
        const SizedBox(width: 8),
        buildAttributeTag("Qty: $quantity", context),
      ],
    );
  }
}