import 'package:flutter/material.dart';

class OrderCostSummary extends StatelessWidget {
  final double itemsTotal;
  final double shipping;
  final double tax;
  final double total;
  final double discount;

  const OrderCostSummary({
    Key? key,
    required this.itemsTotal,
    required this.shipping,
    required this.tax,
    required this.total,
    this.discount = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(context, 'Items Total', '\$${itemsTotal.toStringAsFixed(2)}'),
          if (discount > 0)
            _buildSummaryRow(context, 'Discount', '-\$${discount.toStringAsFixed(2)}'),
          _buildSummaryRow(context, 'Shipping', '\$${shipping.toStringAsFixed(2)}'),
          _buildSummaryRow(context, 'Tax', '\$${tax.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildSummaryRow(
            context,
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isBold = false}) {
    final textStyle = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 16 : 14,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}