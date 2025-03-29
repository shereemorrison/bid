import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class OrderCostSummary extends StatelessWidget {
  final double itemsTotal;
  final double shipping;
  final double tax;
  final double total;

  const OrderCostSummary({
    super.key,
    required this.itemsTotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.cardBackground,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          buildCostItem(context, 'Items', formatPrice(itemsTotal)),
          const SizedBox(height: 8),
          buildCostItem(context, 'Shipping', formatPrice(shipping)),
          const SizedBox(height: 8),
          buildCostItem(context, 'Tax', formatPrice(tax)),

          Divider(
            height: 24,
            thickness: 1,
            color: Theme
                .of(context)
                .colorScheme
                .borderColor,
          ),

          buildCostItem(context, 'Total', formatPrice(total), isTotal: true),
        ],
      ),
    );
  }
}
