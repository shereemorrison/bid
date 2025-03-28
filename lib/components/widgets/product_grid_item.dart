
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    return GestureDetector(
        onTap: () {
          // Navigate to product detail page
          context.push('/shop/product', extra: product);
        },

    child: Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                // Loading Placeholder
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.textPrimary,
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
                    color: Theme.of(context).colorScheme.cardBackground,
                    child: Center(
                      child: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.textPrimary),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.accent,
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
    )
    );
  }
}

