
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/components/widgets/empty_state.dart';
import 'package:bid/components/cards/cart_item_card.dart';
import 'package:bid/components/widgets/order_summary.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/routes/route.dart';
import 'package:bid/services/cart_service.dart';
import '../models/products_model.dart';


@RoutePage()
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
    double totalAmount = cart.fold(0.0, (sum, item) => sum + item.price);

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
            child: _buildCartItemsList(cart.cast<Product>()),
          ),
          OrderSummary(
            totalAmount: totalAmount,
            onCheckout: () {
              context.pushRoute(OrderSummaryRoute());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList(List<Product> cart) {
    return ListView.builder(
      itemCount: cart.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final item = cart[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CartItemCard(
            product: item,
            onRemove: () => _cartService.removeFromCart(context, item),
          ),
        );
      },
    );
  }
}

@RoutePage()
class CartRootPage extends StatelessWidget {
  const CartRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}