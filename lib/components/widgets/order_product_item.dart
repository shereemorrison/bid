import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/models/products_model.dart';

class OrderProductItem extends StatelessWidget {
  final dynamic product;

  const OrderProductItem({
    super.key,
    required this.product,
  });

  // Helper method to check if a path is a URL
  bool _isUrl(String path) {
    return path.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final Product typedProduct = product as Product;

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
                width: 80,
                height: 80,
                child: _buildProductImage(context, typedProduct),
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
                    "\$${typedProduct.price.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildAttributeTag("Size: M", context),
                      const SizedBox(width: 8),
                      _buildAttributeTag("Qty: 1", context),
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

  Widget _buildProductImage(BuildContext context, Product product) {
    if (_isUrl(product.imageUrl)) {
      return Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Theme.of(context).colorScheme.cardBackground,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.textPrimary,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.cardBackground,
            child: Center(
              child: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.textPrimary),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        product.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.cardBackground,
            child: Center(
              child: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.textPrimary),
            ),
          );
        },
      );
    }
  }

  Widget _buildAttributeTag(String text, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.borderColor),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.textSecondary,
        ),
      ),
    );
  }
}

