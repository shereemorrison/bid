import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/models/product_model.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:bid/utils/ui_helpers.dart';
import 'package:bid/utils/format_helpers.dart';

class OrderProductItem extends StatelessWidget {
  final dynamic product;

  const OrderProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final Product typedProduct = product as Product;
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
                width: 80,
                height: 80,
                child: buildProductImage(
                    context, typedProduct.imageUrl, typedProduct.imagePath),
              ),
            ),

            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typedProduct.name,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    formatPrice(typedProduct.price),
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (typedProduct.selectedSize != null &&
                          typedProduct.selectedSize!.isNotEmpty)
                      buildAttributeTag("Size: ${typedProduct.selectedSize ?? 'N/A'}",
                          context
                      ),
                      const SizedBox(width: 8),
                      buildAttributeTag("Qty: ${typedProduct.quantity}",
                          context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
