
import 'package:bid/components/cart_widgets/empty_state.dart';
import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/list_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  void _removeFromWishlist(Product product) {
    ref.read(wishlistProvider.notifier).removeFromWishlist(product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} removed from wishlist'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCart(Product product) {
    // Use your existing addToCart method that takes a Product directly
    ref.read(cartProvider.notifier).addToCart(product);
  }

  @override
  Widget build(BuildContext context) {
    // Get wishlist product IDs
    final wishlistProductIds = ref.watch(wishlistItemsProvider);

    // Get all products
    final allProducts = ref.watch(allProductsProvider);

    // Filter products that are in the wishlist
    final List<Product> wishlistProducts = allProducts
        .where((product) => wishlistProductIds.contains(product.id))
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: wishlistProducts.isEmpty
          ? const EmptyState(
        icon: Icons.favorite_border,
        title: "Your wishlist is empty",
        subtitle: "Save items you love to your wishlist",
      )
      // Use the list helper
          : buildWishlistItemsList(
        wishlistProducts,
            (item) => _removeFromWishlist(item),
            (item) => _addToCart(item),
      ),
    );
  }
}