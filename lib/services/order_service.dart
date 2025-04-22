import 'package:bid/models/order_model.dart';
import 'package:bid/services/order_creator_service.dart';
import 'package:bid/services/order_query_service.dart';
import 'package:bid/services/order_return_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

final orderServiceProvider = riverpod.Provider<OrderService>((ref) {
  final supabase = Supabase.instance.client;
  return OrderService(
    orderCreator: OrderCreatorService(supabase),
    orderQuery: OrderQueryService(supabase),
    orderReturn: OrderReturnService(supabase),
  );
});

/// Main facade that delegates to specialized services
class OrderService {
  final OrderCreatorService orderCreator;
  final OrderQueryService orderQuery;
  final OrderReturnService orderReturn;

  OrderService({
    required this.orderCreator,
    required this.orderQuery,
    required this.orderReturn,
  });

  // Delegated methods for order creation
  Future<Map<String, dynamic>> createOrderFromCheckout({
    required String userId,
    required List<dynamic> products,
    required dynamic shippingAddress,
    required double subtotal,
    required double tax,
    required double shipping,
    required double total,
    required String paymentMethod,
    String? paymentIntentId,
    bool isGuestCheckout = false,
  }) {
    return orderCreator.createOrderFromCheckout(
      userId: userId,
      products: products,
      shippingAddress: shippingAddress,
      subtotal: subtotal,
      tax: tax,
      shipping: shipping,
      total: total,
      paymentMethod: paymentMethod,
      paymentIntentId: paymentIntentId,
      isGuestCheckout: isGuestCheckout,
    );
  }

  Future<Order> createOrder(Order order) {
    return orderCreator.createOrder(order);
  }

  // Delegated methods for order queries
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return orderQuery.getUserOrders(userId);
  }

  Future<Map<String, dynamic>?> getOrderDetails(String orderId) {
    return orderQuery.getOrderDetails(orderId);
  }

  // Delegated methods for returns
  Future<void> initiateReturn(String orderId, List<String> itemIds) {
    return orderReturn.initiateReturn(orderId, itemIds);
  }
}
