import 'package:bid/components/auth/auth_modal.dart';
import 'package:bid/components/auth/checkout_auth_options.dart';
import 'package:bid/components/order_widgets/order_cost_summary.dart';
import 'package:bid/components/order_widgets/order_product_item.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/utils/order_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
  void _handleCheckoutTap() {
    final isLoggedIn = ref.read(isLoggedInProvider);

    if (isLoggedIn) {
      // User is already logged in, proceed to checkout
      widget.onProceed();
    } else {
      // Show auth options dialog
      _showAuthOptionsDialog();
    }
  }

  void _showAuthOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CheckoutAuthOptions(
          onOptionSelected: (option) {
            Navigator.pop(context); // Close the options dialog

            switch (option) {
              case CheckoutAuthOption.login:
                _showAuthModal(AuthModalType.login);
                break;
              case CheckoutAuthOption.register:
                _showAuthModal(AuthModalType.register);
                break;
              case CheckoutAuthOption.guest:
              // Proceed as guest
                widget.onProceed();
                break;
            }
          },
          showCloseButton: true,
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  void _showAuthModal(AuthModalType type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuthModal(
          initialType: type,
          onLoginSuccess: () {
            Navigator.pop(context); // Close the auth modal
            widget.onProceed(); // Proceed to checkout
          },
          onRegisterSuccess: () {
            Navigator.pop(context); // Close the auth modal
            widget.onProceed(); // Proceed to checkout
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isLoggedIn = ref.watch(isLoggedInProvider);

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
              onPressed: _handleCheckoutTap,
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
}
