import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import '../../models/products_model.dart';
import '../buttons/shopping_buttons.dart';

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

  // Helper method to check if a path is a URL
  bool _isUrl(String path) {
    return path.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
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
                width: 100,
                height: 100,
                child: _buildProductImage(context),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Add to Cart Button
                  AddToCartButton(
                    onTap: onAddToCart,
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
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    // Check for empty paths
    if (product.imageUrl.isEmpty && product.imagePath.isEmpty) {
      return Container(
        color: Colors.grey,
        child: Center(
          child: Icon(Icons.image_not_supported, color: Theme.of(context).colorScheme.primary),
        ),
      );
    }

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
          print('Error loading image: $error');
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
          print('Error loading asset: $error');
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
}

