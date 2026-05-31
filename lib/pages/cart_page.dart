
import 'package:bid/components/cart_widgets/empty_state.dart';
import 'package:bid/components/order_widgets/order_summary.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/list_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  void _showCheckoutOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Checkout options',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/account/login?redirect=/cart/checkout');
                  },
                  child: const Text('Log in to checkout'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/cart/checkout');
                  },
                  child: const Text('Checkout as guest'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Reset checkout state when entering cart page - delay to avoid modifying providers during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetCheckoutStateFromWidget(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartItemsProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
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
                cart,
                    (item) => ref.read(cartProvider.notifier).removeFromCart(item.id)
            ),
          ),
          OrderSummary(
            totalAmount: totalAmount,
            onCheckout: () {
              if (isLoggedIn) {
                context.push('/cart/checkout');
              } else {
                _showCheckoutOptions();
              }
            },
          ),
        ],
      ),
    );
  }
}