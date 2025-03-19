
import '../providers/order_provider.dart';
import 'order_item_model.dart';

class Order {
  final String orderId;
  final DateTime orderDate;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
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
      items: orderItems,
    );
  }
}