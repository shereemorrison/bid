

import 'package:bid/components/common_widgets/empty_state.dart';
import 'package:bid/components/order_widgets/order_summary.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/utils/list_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/cart_service.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;
    double totalAmount = cart.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: cart.isEmpty
          ? const EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: "Your shopping bag is empty",
        subtitle: "Items added to your bag will appear here",
      )
          : Column(
        children: [
          Expanded(
            child: buildCartItemsList(
                cart.cast<Product>(),
                    (item) => _cartService.removeFromCart(context, item)
            ),
          ),
          OrderSummary(
            totalAmount: totalAmount,
            onCheckout: () {
              context.push('/cart/summary');
            },
          ),
        ],
      ),
    );
  }
}