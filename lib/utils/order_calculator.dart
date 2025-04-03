import 'package:bid/models/order_item_model.dart';
import 'package:bid/models/products_model.dart';

class OrderCalculator {
  /// Calculates the subtotal from order items
  static double calculateSubtotal(List<dynamic> items) {
    return items.fold(0.0, (sum, item) {
      // Handle both OrderItem and Product types
      if (item is OrderItem) {
        return sum + (item.price * item.quantity);
      } else if (item is Product) {
        return sum + (item.price * item.quantity);
      }
      return sum;
    });
  }

  /// Calculates the subtotal specifically from Product objects
  static double calculateProductSubtotal(List<Product> products) {
    return products.fold(0.0, (sum, product) => sum + (product.price * product.quantity));
  }

  /// Calculates the subtotal specifically from OrderItem objects
  static double calculateOrderItemSubtotal(List<OrderItem> orderItems) {
    return orderItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// Calculates tax amount based on subtotal
  static double calculateTax(double subtotal, {double taxRate = 0.1}) {
    return subtotal * taxRate;
  }

  /// Calculates the total amount
  static double calculateTotal({
    required double subtotal,
    required double taxAmount,
    required double shippingAmount,
    required double discountAmount,
  }) {
    return subtotal + taxAmount + shippingAmount - discountAmount;
  }

  /// Recalculates all order values and returns a map with the results
  static Map<String, double> calculateOrderTotals({
    required List<dynamic> items,
    double shippingAmount = 0.0,
    double discountAmount = 0.0,
    double taxRate = 0.1,
  }) {
    final subtotal = calculateSubtotal(items);
    final taxAmount = calculateTax(subtotal, taxRate: taxRate);
    final totalAmount = calculateTotal(
      subtotal: subtotal,
      taxAmount: taxAmount,
      shippingAmount: shippingAmount,
      discountAmount: discountAmount,
    );

    return {
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'shippingAmount': shippingAmount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
    };
  }

}

