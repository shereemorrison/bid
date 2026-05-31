import 'package:bid/components/order_widgets/order_cost_summary.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderConfirmationHelper {
  static void clearCartAndCheckoutState(WidgetRef ref) {
    try {
      ref.read(cartProvider.notifier).clearCart();
    } catch (_) {}
  }

  static Widget buildOrderSummary(
    Map<String, dynamic>? orderDetails,
    ColorScheme colorScheme,
  ) {
    if (orderDetails == null) return const SizedBox.shrink();
    return OrderCostSummary.fromOrderMap(orderDetails);
  }
}
