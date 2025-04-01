
// ignore: unused_import
import 'package:bid/components/cards/wishlist_item_card.dart';
import 'package:bid/components/common_widgets/empty_state.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/utils/list_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/wishlist_service.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: wishlist.isEmpty
          ? const EmptyState(
        icon: Icons.favorite_border,
        title: "Your wishlist is empty",
        subtitle: "Save items you love to your wishlist",
      )
      // Use the list helper
          : buildWishlistItemsList(
        wishlist.cast<Product>(),
            (item) => _wishlistService.removeFromWishlist(context, item),
            (item) => _wishlistService.addToCart(context, item),
      ),
    );
  }
}