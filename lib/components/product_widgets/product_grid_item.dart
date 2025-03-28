
import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/dialog_service.dart';
import 'package:bid/services/product_service.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
        onTap: () {
          // Navigate to product detail page
          context.push('/shop/product', extra: product);
        },

    child: Card(
      color: colorScheme.surface,
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
              child: buildProductImage(context, product.imageUrl, product.imagePath),
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
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  formatPrice(product.price),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.accent,
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

