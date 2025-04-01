import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/models/products_model.dart';
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Theme
            .of(context).colorScheme.cardBackground,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(typedProduct.price),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      buildAttributeTag("Size: M", context),
                      const SizedBox(width: 8),
                      buildAttributeTag("Qty: 1", context),
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
