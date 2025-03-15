
import 'package:auto_route/annotations.dart';
import 'package:bid/archive/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/components/widgets/empty_state.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/wishlist_service.dart';

import '../components/cards/wishlist_item_card.dart';
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
          : _buildWishlistItemsList(wishlist.cast<Product>()),
    );
  }

  Widget _buildWishlistItemsList(List<Product> wishlist) {
    return ListView.builder(
      itemCount: wishlist.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final item = wishlist[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: WishlistItemCard(
            product: item,
            onRemove: () => _wishlistService.removeFromWishlist(context, item),
            onAddToCart: () => _wishlistService.addToCart(context, item),
          ),
        );
      },
    );
  }
}