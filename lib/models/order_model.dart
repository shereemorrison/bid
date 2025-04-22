
import 'package:bid/utils/order_calculator.dart';

import 'order_item_model.dart';

class Order {
  final String orderId;
  final String userId;
  final DateTime orderDate;
  final String status;
  final Map<String, dynamic>? orderStatus;
  final double taxAmount;
  final double shipping_amount;
  final double discount_amount;
  final double totalAmount;
  final String? shippingMethod;
  final String? trackingNumber;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.userId,
    required this.orderDate,
    this.orderStatus,
    required this.status,
    required this.taxAmount,
    required this.shipping_amount,
    required this.discount_amount,
    required this.totalAmount,
    this.shippingMethod,
    this.trackingNumber,
    this.shippedAt,
    this.deliveredAt,
    required this.items,
  });

  double get subtotal => OrderCalculator.calculateSubtotal(items);

  // Recalculate the total for validation
  double get calculatedTotal => OrderCalculator.calculateTotal(
    subtotal: subtotal,
    taxAmount: taxAmount,
    shippingAmount: shipping_amount,
    discountAmount: discount_amount,
  );

  bool get isTotalValid => (calculatedTotal - totalAmount).abs() < 0.01;

  void validateTotals() {
    if (!isTotalValid) {
      print('WARNING: Order $orderId has inconsistent totals');
      //print('Stored total: $totalAmount');
      //print('Calculated total: $calculatedTotal');

      // Check if there might be an undocumented discount
      if (discount_amount == 0 && calculatedTotal > totalAmount) {
        final possibleDiscount = calculatedTotal - totalAmount;
        //print('Possible undocumented discount: $possibleDiscount');
      }
    }
  }


  factory Order.fromJson(Map<String, dynamic> json) {
    // print('Order data: $json');
    // print('Status: ${json['status']}');
    // print('Order status: ${json['order_status']}');
    // Handle the case where status might be null
    String statusName = 'Unknown';
    if (json['status'] != null && json['status'] is String) {
      statusName = json['status'];
    } else if (json['status'] != null && json['status'] is Map) {
      statusName = json['status']['name'] ?? 'Unknown';
    } else if (json['order_status'] != null && json['order_status'] is Map) {
      statusName = json['order_status']['name'] ?? 'Unknown';
    } else if (json['status_id'] != null) {
      statusName = 'Status ID: ${json['status_id']}';
    }

    // Handle the case where order_items might be missing
    List<OrderItem> orderItems = [];
    if (json['order_items'] != null && json['order_items'] is List) {
      try {
        orderItems = (json['order_items'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList();
      } catch (e) {
        print('Error parsing order items: $e');
      }
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) {
        try {
          return double.parse(value);
        } catch (_) {
          return 0.0;
        }
      }
      return 0.0;
    }

    // Parse dates
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return null;
      }
    }

    return Order(
      orderId: json['order_id'] ?? 'Unknown',
      userId: json['user_id']?.toString() ?? 'Unknown',
      orderDate: json['order_date'] != null ? DateTime.parse(json['order_date']) : DateTime.now(),
      status: statusName,
      orderStatus: json['order_status'],
      totalAmount: parseDouble(json['total_amount']),
      taxAmount: parseDouble(json['tax_amount']),
      shipping_amount: parseDouble(json['shipping_amount']),
      discount_amount: parseDouble(json['discount_amount']),
      shippingMethod: json['shipping_method'],
      trackingNumber: json['tracking_number'],
      shippedAt: parseDate(json['shipped_at']),
      deliveredAt: parseDate(json['delivered_at']),
      items: orderItems,
    );
  }
}