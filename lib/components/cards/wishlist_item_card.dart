import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/components/product_widgets/modal_size_selector.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:flutter/material.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: colorScheme.cardBackground,
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
                child: buildProductImage(
                    context, product.imageUrl, product.imagePath),
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
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(product.price),
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Add to Cart Button
                  AddToCartButton(
                    onTap: () => showSizeSelectorModal(context, product),
                    height: 30,
                    fontSize: 10,
                    width: 120,
                  ),
                ],
              ),
            ),

            CustomIconButton(
              icon: Icons.close,
              onTap: onRemove,
              size: 30,
              iconSize: 20,
              iconColor: colorScheme.textSecondary,
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}