import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/products_model.dart';
import '../../providers/shop_provider.dart';


class ShopProductCard extends StatelessWidget {
  final Product product;
  final bool isLarge;

  const ShopProductCard({
    super.key,
    required this.product,
    this.isLarge = false,
  });

  void addToCart(BuildContext context) {
    // Add item to cart
    context.read<Shop>().addToCart(product);

    // Show confirmation dialog instead of snackbar
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

  void addToWishlist(BuildContext context) {
    // Add item to wishlist
    context.read<Shop>().addToWishlist(product);

    // Show confirmation dialog instead of snackbar
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
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
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
                  style: TextStyle(
                    color: greyShade300,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
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
                      child: ElevatedButton(
                        onPressed: () => addToCart(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customBeige,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          minimumSize: const Size(0, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          textStyle: TextStyle(
                            fontSize: fontSize - 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text("ADD"),
                      ),
                    ),
                    const SizedBox(width: 5),

                    // Add to Wishlist Button
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        onPressed: () => addToWishlist(context),
                        icon: const Icon(Icons.favorite_border, size: 16),
                        padding: EdgeInsets.zero,
                        color: customBeige,
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

