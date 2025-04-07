import 'package:bid/models/order_model.dart';

// Helper method to check if order is eligible for returns
bool isOrderReturnEligible(Order order) {
  // Example logic: Order must be delivered and within 30 days
  if (order.status.toUpperCase() != 'DELIVERED') {
    return false;
  }

  if (order.deliveredAt == null) {
    return false;
  }

  final deliveryDate = order.deliveredAt!;
  final now = DateTime.now();
  final difference = now.difference(deliveryDate).inDays;

  // Allow returns within 30 days of delivery
  return difference <= 30;
}

