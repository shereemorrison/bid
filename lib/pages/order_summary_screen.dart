import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/shop_provider.dart';

import '../components/buttons/shopping_buttons.dart';
import '../components/cards/order_info_card.dart';
import '../components/widgets/order_cost_summary.dart';
import '../components/widgets/order_payment.option.dart';
import '../components/widgets/order_product_item.dart';
import '../routes/route.dart';

@RoutePage()
class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get cart items from the Shop provider
    final cart = context.watch<Shop>().cart;

    // Calculate totals
    final double itemsTotal = cart.fold(0.0, (sum, item) => sum + item.price);
    final double shipping = 10.0;
    final double tax = itemsTotal * 0.1;
    final double total = itemsTotal + shipping + tax;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              OrderInfoCard(
                text: 'Address',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // Payment Method
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
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
                itemsTotal: itemsTotal,
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
                      onTap: () => context.router.pop(),
                      textColor: Theme.of(context).colorScheme.secondary,
                      borderColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AddToCartButton(
                      text: "CONTINUE",
                      onTap: () {
                        context.pushRoute(const WelcomeRoute());
                      },
                      textColor: Theme.of(context).colorScheme.secondary,
                      borderColor: Theme.of(context).colorScheme.secondary,
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

