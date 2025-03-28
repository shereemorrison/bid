import 'package:bid/themes/custom_colors.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/products_model.dart';
import '../../providers/shop_provider.dart';
import '../buttons/shopping_buttons.dart';


class ShopProductCard extends StatelessWidget {
  final Product product;
  final bool isLarge;

  const ShopProductCard({
    super.key,
    required this.product,
    this.isLarge = false,
  });

  void addToCart(BuildContext context) {
    context.read<Shop>().addToCart(product);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.cardBackground,
        content: Text(
          "Added ${product.name} to cart",
          style: TextStyle(color: Theme.of(context).colorScheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Theme.of(context).colorScheme.accent),
            ),
          ),
        ],
      ),
    );
  }

  void addToWishlist(BuildContext context) {
    context.read<Shop>().addToWishlist(product);

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
    final greyShade300 = Colors.grey.shade300;
    final customBeige = Theme.of(context).colorScheme.secondary;

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
                image: AssetImage(product.imagePath),
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
                    color: customBeige,
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
                        onTap: () => addToCart(context),
                        height: 30,
                        fontSize: fontSize - 2,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // Add to Wishlist Button (icon button)
                    CustomIconButton(icon: Icons.favorite_border,
                      onTap: () => addToWishlist(context),
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