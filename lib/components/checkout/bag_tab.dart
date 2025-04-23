import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/order_widgets/order_cost_summary.dart';
import '../../components/order_widgets/order_product_item.dart';
import '../../providers/shop_provider.dart';
import '../../utils/order_calculator.dart';

class BagTab extends ConsumerStatefulWidget {
  final VoidCallback onProceed;

  const BagTab({
    Key? key,
    required this.onProceed,
  }) : super(key: key);

  @override
  ConsumerState<BagTab> createState() => _BagTabState();
}

class _BagTabState extends ConsumerState<BagTab> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // ADDED: Check if cart is empty
    if (cart.isEmpty) {
      return _buildEmptyCart(colorScheme);
    }

    // Calculate totals
    final double subtotal = OrderCalculator.calculateProductSubtotal(cart);
    final double shipping = 10.0;
    final double discount = 0.0; // Add discount logic if needed
    final double tax = OrderCalculator.calculateTax(subtotal);
    final double total = OrderCalculator.calculateTotal(
      subtotal: subtotal,
      taxAmount: tax,
      shippingAmount: shipping,
      discountAmount: discount,
    );

    return Column(
      children: [
        // Main content - scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Products section
                Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Display cart items
                ...cart.map((product) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OrderProductItem(product: product),
                    )
                ).toList(),

                const SizedBox(height: 24),

                // Cost summary
                OrderCostSummary(
                  itemsTotal: subtotal,
                  shipping: shipping,
                  tax: tax,
                  total: total,
                ),
              ],
            ),
          ),
        ),

        // Bottom button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.onProceed, // Directly proceed without auth check
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                'CONTINUE TO SHIPPING',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ADDED: Method to build empty cart view
  Widget _buildEmptyCart(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your cart to begin checkout',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to shop
              Navigator.of(context).pushNamedAndRemoveUntil('/shop', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: const Text(
              'SHOP NOW',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
