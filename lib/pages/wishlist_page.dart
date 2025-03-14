import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/components/ProductCard.dart';
import '../models/products.dart';
import '../models/shop.dart';

@RoutePage()
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Remove item from wishlist
  void removeItemFromWishlist(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        content: const Text(
          "Remove this from your wishlist?",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          // Yes button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().removeFromWishlist(product);
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Add to cart
  void addToCart(BuildContext context, Product product) {
    context.read<Shop>().addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart"),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<Shop>().wishlist;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: wishlist.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 70,
            ),
            const SizedBox(height: 20),
            Text(
              "Your wishlist is empty",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Save items you love to your wishlist",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6, // Adjust aspect ratio for better card sizing
            crossAxisSpacing: 8,  // Reduce spacing for better card fit
            mainAxisSpacing: 8,   // Reduce spacing for better card fit
          ),
          itemCount: wishlist.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final item = wishlist[index];
            return ProductCard(
              onAddToCart: () => addToCart(context, item),
              removeitemfromWishlist: () => removeItemFromWishlist(context, item),
              product: item,
            );
          },
        ),
      ),
    );
  }
}
