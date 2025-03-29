import 'package:flutter/material.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/components/cards/wishlist_item_card.dart';
import 'package:bid/components/cards/cart_item_card.dart';

// Helper for building wishlist items list
Widget buildWishlistItemsList(
    List<Product> wishlist,
    Function(Product) onRemove,
    Function(Product) onAddToCart
    ) {
  return ListView.builder(
    itemCount: wishlist.length,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemBuilder: (context, index) {
      final item = wishlist[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: WishlistItemCard(
          product: item,
          onRemove: () => onRemove(item),
          onAddToCart: () => onAddToCart(item),
        ),
      );
    },
  );
}

// Helper for building cart items list
Widget buildCartItemsList(
    List<Product> cart,
    Function(Product) onRemove
    ) {
  return ListView.builder(
    itemCount: cart.length,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemBuilder: (context, index) {
      final item = cart[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CartItemCard(
          product: item,
          onRemove: () => onRemove(item),
        ),
      );
    },
  );
}

