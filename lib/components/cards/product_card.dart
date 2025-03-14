
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/products_model.dart';
import '../../providers/shop_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product; // Product model
  final VoidCallback onAddToCart;
  final VoidCallback removeitemfromWishlist;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.removeitemfromWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add product to the cart by calling the Shop's addToCart method
        context.read<Shop>().addToCart(product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Remove Button
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,  // Keep height consistent as per your design
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage(product.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned remove button in top right corner
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      // Remove product from wishlist
                      context.read<Shop>().removeFromWishlist(product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Product Price
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
                      // Add product to cart when the button is pressed
                      context.read<Shop>().addToCart(product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
          ],
        ),
      ),
    );
  }
}
