import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/products_model.dart';
import '../../providers/shop_provider.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({
    super.key,
    required this.product,
  });

  //Add to cart Helper
  void _showAddToCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          "Added ${product.name} to cart",
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
    );
  }

  //Wishlist helper
  void _showAddToWishlistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          "Added ${product.name} to wishlist",
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),

                // Action Buttons
                Row(
                  children: [
                    // Add to Cart Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<Shop>().addToCart(product);
                          _showAddToCartDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          minimumSize: const Size(0, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text("Add to Cart"),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Add to Wishlist Button
                    InkWell(
                      onTap: () {
                        context.read<Shop>().addToWishlist(product);
                        _showAddToWishlistDialog(context);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

