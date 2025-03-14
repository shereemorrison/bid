
import 'package:auto_route/annotations.dart';
import 'package:bid/components/cards/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/components/widgets/empty_state.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/wishlist_service.dart';

import '../models/products_model.dart';

@RoutePage()
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<Shop>().wishlist;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: wishlist.isEmpty
          ? const EmptyState(
        icon: Icons.favorite_border,
        title: "Your wishlist is empty",
        subtitle: "Save items you love to your wishlist",
      )
          : _buildWishlistGrid(wishlist.cast<Product>()),
    );
  }

  Widget _buildWishlistGrid(List<Product> wishlist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: wishlist.length,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) {
          final item = wishlist[index];
          return ProductCard(
            onAddToCart: () => _wishlistService.addToCart(context, item),
            removeitemfromWishlist: () => _wishlistService.removeFromWishlist(context, item),
            product: item,
          );
        },
      ),
    );
  }
}