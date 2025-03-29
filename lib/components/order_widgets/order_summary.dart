import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onCheckout;
  final double? subtotal;
  final double? shipping;
  final double? tax;

  const OrderSummary({
    super.key,
    required this.totalAmount,
    required this.onCheckout,
    this.subtotal,
    this.shipping,
    this.tax,
  });

  @override
  Widget build(BuildContext context) {

    final double displaySubtotal = subtotal ?? totalAmount;
    final double displayShipping = shipping ?? 0.0;
    final double displayTax = tax ?? 0.0;
    final double displayTotal = subtotal != null ? (displaySubtotal + displayShipping + displayTax) : totalAmount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              Text(
                "\$${displayTotal.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: BaseStyledButton(
              text: "CHECKOUT",
              onTap: onCheckout,
              height: 50,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}