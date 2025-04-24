
import 'package:bid/utils/order_calculator.dart';

import 'order_item_model.dart';

class Order {
  final String orderId;
  final String userId;
  final DateTime orderDate;
  final String status;
  final Map<String, dynamic>? orderStatus;
  final double taxAmount;
  final double shippingAmount;
  final double discountAmount;
  final double totalAmount;
  final String? shippingMethod;
  final String? trackingNumber;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final List<OrderItem> items;
  final Map<String, dynamic>? shippingAddress;
  final String? paymentMethod;

  Order({
    required this.orderId,
    required this.userId,
    required this.orderDate,
    this.orderStatus,
    required this.status,
    required this.taxAmount,
    required this.shippingAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.shippingMethod,
    this.trackingNumber,
    this.shippedAt,
    this.deliveredAt,
    required this.items,
    this.shippingAddress,
    this.paymentMethod,


  });


  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'tax_amount': taxAmount,
      'shipping_amount': shippingAmount,
      'discount_amount': discountAmount,
      'total_amount': totalAmount,
      'shipping_method': shippingMethod,
      'tracking_number': trackingNumber,
      'shipped_at': shippedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'shipping_address': shippingAddress,
      'payment_method': paymentMethod,
    };
  }

  double get subtotal => OrderCalculator.calculateSubtotal(items);

  // Recalculate the total for validation
  double get calculatedTotal => OrderCalculator.calculateTotal(
    subtotal: subtotal,
    taxAmount: taxAmount,
    shippingAmount: shippingAmount,
    discountAmount: discountAmount,
  );

  bool get isTotalValid => (calculatedTotal - totalAmount).abs() < 0.01;

  bool get isReturnEligible {

    // Order must be delivered to be eligible for return
    if (status != 'DELIVERED') return false;

    // If there's no delivery date, we'll still allow returns if status is DELIVERED
    if (deliveredAt == null) return true;

    // Check if it's within the return window (30 days)
    final returnWindowDays = 30;
    final now = DateTime.now();
    final returnDeadline = deliveredAt!.add(Duration(days: returnWindowDays));

    return now.isBefore(returnDeadline);
  }

  // Check if an item is eligible for return
  bool isItemReturnEligible(OrderItem item) {
    // First check if the order itself is eligible
    if (!isReturnEligible) return false;

    // Check if the item is returnable and not already returned/pending
    return item.isReturnable ?? true && !item.isReturned && !item.isReturnPending;
  }


  void validateTotals() {
    if (!isTotalValid) {
      print('WARNING: Order $orderId has inconsistent totals');
      //print('Stored total: $totalAmount');
      //print('Calculated total: $calculatedTotal');

      // Check if there might be an undocumented discount
      if (discountAmount == 0 && calculatedTotal > totalAmount) {
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
      shippingAmount: parseDouble(json['shipping_amount']),
      discountAmount: parseDouble(json['discount_amount']),
      shippingMethod: json['shipping_method'],
      trackingNumber: json['tracking_number'],
      shippedAt: parseDate(json['shipped_at']),
      deliveredAt: parseDate(json['delivered_at']),
      items: orderItems,
    );
  }
}