import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/services/dialog_service.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopProductCard extends ConsumerWidget {
  final Product product;
  final bool isLarge;

  const ShopProductCard({
    super.key,
    required this.product,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final cartNotifier = ref.read(cartProvider.notifier);
    final wishlistNotifier = ref.read(wishlistProvider.notifier);


    // Adjust dimensions based on size
    final double cardWidth = isLarge ? 180.0 : 150.0;
    final double imageHeight = isLarge ? 180.0 : 120.0;
    final double fontSize = isLarge ? 14.0 : 12.0;
    final double priceFontSize = isLarge ? 14.0 : 12.0;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cardBackground,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: priceFontSize,
                  ),
                ),
                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  children: [
                    // Add to Cart Button
                    Expanded(
                      child: BaseStyledButton(
                        text: "ADD",
                        onTap: () {
                          cartNotifier.addToCart(product);
                          DialogService.showAddToCartDialog(context, product);
                        },
                        height: 30,
                        fontSize: fontSize - 2,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // Add to Wishlist Button (icon button)
                    CustomIconButton(icon: Icons.favorite_border,
                      onTap: () {
                        wishlistNotifier.addToWishlist(product.id);
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