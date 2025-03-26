

import 'order_item_model.dart';

class Order {
  final String orderId;
  final DateTime orderDate;
  final String status;
  final double taxAmount;
  final double shippingAmount;
  final double discountAmount;
  final double totalAmount;
  final String? shippingMethod;
  final String? trackingNumber;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.orderDate,
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
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Handle the case where status might be null
    String statusName = 'Unknown';
    if (json['order_status'] != null && json['order_status'] is Map) {
      statusName = json['order_status']['name'] ?? 'Unknown';
    } else if (json['status'] != null && json['status'] is Map) {
      statusName = json['status']['name'] ?? 'Unknown';
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

    return Order(
      orderId: json['order_id'] ?? 'Unknown',
      orderDate: json['order_date'] != null ? DateTime.parse(json['order_date']) : DateTime.now(),
      status: statusName,
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      taxAmount: json['tax_amount']?.toDouble() ?? 0.0,
      shippingAmount: json['shippingAmount']?.toDouble() ?? 0.0,
      discountAmount: json['discountAmount']?.toDoubke() ?? 0.0,
      items: orderItems,
    );
  }
}