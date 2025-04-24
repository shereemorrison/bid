import 'package:bid/pages/checkout_page.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/format_helpers.dart';

class OrderConfirmationHelper {
  // Clear cart and checkout state
  static void clearCartAndCheckoutState(WidgetRef ref) {
    try {
      // Use clearCart() method instead of trying to set state directly
      ref.read(cartProvider.notifier).clearCart();
    } catch (e) {
      print('Error clearing cart: $e');
    }

    try {
      ref.read(checkoutCompleteProvider.notifier).state = true;
    } catch (e) {
      print('Note: Checkout providers not available: $e');
    }
  }

  // Build order summary widget
  static Widget buildOrderSummary(Map<String, dynamic>? orderDetails, ColorScheme colorScheme) {
    if (orderDetails == null) {
      return const SizedBox.shrink();
    }

    final orderItems = List<Map<String, dynamic>>.from(orderDetails['order_items'] ?? []);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Order items
          ...orderItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['quantity']}x ${item['product_name'] ?? 'Product'}',
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
                ),
                Text(
                  formatPrice(item['total'] ?? 0.0),
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
                ),
              ],
            ),
          )),

          const Divider(height: 24),

          // Order totals
          _buildOrderTotal(
            label: 'Subtotal',
            value: orderDetails['subtotal'] ?? 0.0,
            colorScheme: colorScheme,
            isBold: false,
          ),
          const SizedBox(height: 8),
          _buildOrderTotal(
            label: 'Shipping',
            value: orderDetails['shipping_amount'] ?? 0.0,
            colorScheme: colorScheme,
            isBold: false,
          ),
          const SizedBox(height: 8),
          _buildOrderTotal(
            label: 'Tax',
            value: orderDetails['tax_amount'] ?? 0.0,
            colorScheme: colorScheme,
            isBold: false,
          ),
          const Divider(height: 24),
          _buildOrderTotal(
            label: 'Total',
            value: orderDetails['total_amount'] ?? 0.0,
            colorScheme: colorScheme,
            isBold: true,
          ),
        ],
      ),
    );
  }

  // Helper method to build order total row
  static Widget _buildOrderTotal({
    required String label,
    required double value,
    required ColorScheme colorScheme,
    required bool isBold,
  }) {
    final textStyle = isBold
        ? TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)
        : TextStyle(color: colorScheme.onSurface);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textStyle),
        Text(formatPrice(value), style: textStyle),
      ],
    );
  }
}
