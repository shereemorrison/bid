
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1E1E1E),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProductAttributes(),
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
              iconColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    // Check if the image path is a URL
    if (_isUrl(product.imageUrl)) {
      return Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade800,
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
            color: Colors.grey.shade800,
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.white),
            ),
          );
        },
      );
    } else {
      // Use local asset
      return Image.asset(
        product.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading asset: $error');
          return Container(
            color: Colors.grey.shade800,
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.white),
            ),
          );
        },
      );
    }
  }

  Widget _buildProductAttributes() {
    return Row(
      children: [
        _buildAttributeTag("Size: "),
        const SizedBox(width: 8),
        _buildAttributeTag("Qty: "),
      ],
    );
  }

  Widget _buildAttributeTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700]!),
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

