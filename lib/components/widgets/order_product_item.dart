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
        borderRadius: BorderRadius.circular(12),
        color: isLightMode ? Colors.white : Theme.of(context).colorScheme.quaternary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${typedProduct.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
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
            color: Theme.of(context).colorScheme.senary,
            child: Center(
              child: CircularProgressIndicator(
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
            color: Theme.of(context).colorScheme.senary,
            child: Center(
              child: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.primary),
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
            color: Theme.of(context).colorScheme.senary,
            child: Center(
              child: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.primary),
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
        border: Border.all(color: Theme.of(context).colorScheme.septenary),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}

