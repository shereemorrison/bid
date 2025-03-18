import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/products_model.dart';
import '../../providers/shop_provider.dart';
import '../../services/dialog_service.dart';
import '../../services/product_service.dart';
import '../buttons/shopping_buttons.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final imageUrl = productService.getImageUrl(product.imageUrl);

    return Card(
      color: Colors.grey.shade900,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                // Loading Placeholder
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                // Error handling
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(Icons.error_outline, color: Colors.white),
                    ),
                  );
                },
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
                      child: AddToCartButton(
                        onTap: () {
                          context.read<Shop>().addToCart(product);
                          DialogService.showAddToCartDialog(context, product);
                        },
                        height: 30,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Add to Wishlist Button
                    CustomIconButton(
                      icon: Icons.favorite_border,
                      onTap: () {
                        context.read<Shop>().addToWishlist(product);
                        DialogService.showAddToWishlistDialog(context, product);
                      },
                      size: 30,
                      iconSize: 16,
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

