import 'package:bid/utils/format_helpers.dart';
import 'package:flutter/material.dart';

/// Line item for order cost breakdowns.
class OrderLineItem {
  final String label;
  final double amount;

  const OrderLineItem({required this.label, required this.amount});
}

/// Shared order totals widget — used on order details, confirmation, and guest orders.
class OrderCostSummary extends StatelessWidget {
  final double itemsTotal;
  final double shipping;
  final double tax;
  final double total;
  final double discount;
  final List<OrderLineItem>? lineItems;
  final bool useSquareCorners;

  const OrderCostSummary({
    super.key,
    required this.itemsTotal,
    required this.shipping,
    required this.tax,
    required this.total,
    this.discount = 0.0,
    this.lineItems,
    this.useSquareCorners = false,
  });

  factory OrderCostSummary.fromOrderMap(Map<String, dynamic> orderDetails) {
    final orderItems =
        List<Map<String, dynamic>>.from(orderDetails['order_items'] ?? []);

    return OrderCostSummary(
      itemsTotal: (orderDetails['subtotal'] as num?)?.toDouble() ?? 0,
      shipping: (orderDetails['shipping_amount'] as num?)?.toDouble() ?? 0,
      tax: (orderDetails['tax_amount'] as num?)?.toDouble() ?? 0,
      total: (orderDetails['total_amount'] as num?)?.toDouble() ?? 0,
      discount: (orderDetails['discount_amount'] as num?)?.toDouble() ?? 0,
      useSquareCorners: true,
      lineItems: orderItems
          .map(
            (item) => OrderLineItem(
              label:
                  '${item['quantity']}x ${item['product_name'] ?? 'Product'}',
              amount: (item['total'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = useSquareCorners ? 0.0 : 8.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: useSquareCorners
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: useSquareCorners ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          if (lineItems != null)
            ...lineItems!.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      formatPrice(item.amount),
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (lineItems != null && lineItems!.isNotEmpty)
            const Divider(height: 24),
          _buildSummaryRow(context, 'Subtotal', formatPrice(itemsTotal)),
          if (discount > 0)
            _buildSummaryRow(context, 'Discount', '-${formatPrice(discount)}'),
          _buildSummaryRow(context, 'Shipping', formatPrice(shipping)),
          _buildSummaryRow(context, 'Tax', formatPrice(tax)),
          const Divider(height: 24),
          _buildSummaryRow(
            context,
            'Total',
            formatPrice(total),
            isBold: true,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    ColorScheme? colorScheme,
  }) {
    final scheme = colorScheme ?? Theme.of(context).colorScheme;
    final textStyle = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 16 : 14,
      color: isBold ? scheme.primary : scheme.onSurface,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
