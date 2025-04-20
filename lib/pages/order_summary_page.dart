
import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/components/order_widgets/order_address_card.dart';
import 'package:bid/components/order_widgets/order_cost_summary.dart';
import 'package:bid/components/order_widgets/order_payment.option.dart';
import 'package:bid/components/order_widgets/order_product_item.dart';
import 'package:bid/providers/address_provider.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/utils/order_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bid/components/address_widgets/address_selector.dart';

import '../providers/supabase_auth_provider.dart';
import '../providers/user_provider.dart';

class OrderSummaryPage extends ConsumerStatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  ConsumerState<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends ConsumerState<OrderSummaryPage> {
  bool _showAddressSelector = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAddresses();
    });
  }

  void _loadAddresses() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    final userData = ref.read(userDataProvider);

    if (isLoggedIn && userData != null) {
      ref.read(addressNotifierProvider.notifier).fetchUserAddresses(userData.userId);
    }
  }


  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final selectedAddress = ref.watch(effectiveAddressProvider);

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

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Products from cart
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
              ...cart.map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OrderProductItem(product: product),
              )).toList(),

              const SizedBox(height: 24),

              // Shipping Information
              Text(
                'Shipping Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              if (_showAddressSelector)
                AddressSelector(
                  onAddressSelected: (address) {
                    setState(() {
                      _showAddressSelector = false;
                    });
                  },
                )
              else
                OrderAddressCard(
                  address: selectedAddress,
                  onTap: () {
                    setState(() {
                      _showAddressSelector = true;
                    });
                  },
                ),

              const SizedBox(height: 24),

              // Payment Method
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OrderPaymentOption(
                      icon: Icons.credit_card,
                      isSelected: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrderPaymentOption(
                      icon: Icons.add,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrderPaymentOption(
                      icon: Icons.person_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Cost Summary
              OrderCostSummary(
                itemsTotal: subtotal,
                shipping: shipping,
                tax: tax,
                total: total,
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: BaseStyledButton(
                      text: "CONTINUE SHOPPING",
                      onTap: () => context.pop(),
                      textColor: colorScheme.secondary,
                      borderColor: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AddToCartButton(
                      text: "CONTINUE",
                      onTap: () {
                        context.pop();
                      },
                      textColor: colorScheme.secondary,
                      borderColor: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

