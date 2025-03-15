import 'package:flutter/material.dart';
import '../../models/products_model.dart';

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
                child: Image.asset(
                  '${product.imagePath}',
                  fit: BoxFit.cover,
                ),
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
                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: onAddToCart, // Using the callback passed from parent
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(120, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("ADD TO BAG"),
                  ),
                ],
              ),
            ),
            // Delete Button
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: onRemove, // Using the callback passed from parent
            ),
          ],
        ),
      ),
    );
  }
}

