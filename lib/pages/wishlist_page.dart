
import 'package:bid/components/cart_widgets/empty_state.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/services/shop_service.dart';
import 'package:bid/utils/list_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:bid/archive/wishlist_service.dart';
import 'package:bid/providers/shop_provider.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  final ShopService _shopService = ShopService();

  @override
  Widget build(BuildContext context) {
    final wishlist = ref.watch(shopProvider).wishlist;

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
            (item) => _shopService.removeFromWishlist(context, item, ref),
            (item) => _shopService.addToCart(context, item, ref),
      ),
    );
  }
}