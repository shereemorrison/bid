
import 'order_item_model.dart';

class Order {
  final String orderId;
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

  factory Order.fromJson(Map<String, dynamic> json) {
    print('Order data: $json');
    print('Status: ${json['status']}');
    print('Order status: ${json['order_status']}');
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

    return Order(
      orderId: json['order_id'] ?? 'Unknown',
      orderDate: json['order_date'] != null ? DateTime.parse(json['order_date']) : DateTime.now(),
      status: statusName,
      orderStatus: json['order_status'],
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      taxAmount: json['tax_amount']?.toDouble() ?? 0.0,
      shipping_amount: json['shippingAmount']?.toDouble() ?? 0.0,
      discount_amount: json['discountAmount']?.toDouble() ?? 0.0,
      items: orderItems,
    );
  }
}