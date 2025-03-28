
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import '../../models/products_model.dart';
import '../buttons/shopping_buttons.dart';

class CartItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.product,
    required this.onRemove,
  });

  // Helper method to check if a path is a URL
  bool _isUrl(String path) {
    return path.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
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
            child: _buildProductImage(),
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
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
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

  Widget _buildProductImage() {
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
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Container(
            color: Theme.of(context).colorScheme.primary,
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
          print('Error loading asset: $error');
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

  Widget _buildProductAttributes(context) {
    String size = "M";
    int quantity = product.quantity > 0 ? product.quantity : 1;
    String color = "Grey";

    return Row(
      children: [
        _buildAttributeTag("Size: $size", context),
        const SizedBox(width: 8),
        _buildAttributeTag("Qty: $quantity", context),
      ],
    );
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

