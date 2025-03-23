import 'package:bid/themes/custom_colors.dart';
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
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.white : Theme.of(context).colorScheme.quaternary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCostItem(context, 'Items', '\$${itemsTotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildCostItem(context, 'Shipping', '\$${shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildCostItem(context, 'Tax', '\$${tax.toStringAsFixed(2)}'),

          Divider(
            height: 24,
            thickness: 1,
            color: Theme.of(context).colorScheme.septenary,
          ),

          _buildCostItem(context, 'Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildCostItem(BuildContext context, String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

