import 'package:flutter/foundation.dart';
import '../../models/order_model.dart';

@immutable
class OrdersState {
  final List<Order> orders;
  final Order? selectedOrder;
  final bool isLoading;
  final String? error;

  const OrdersState({
    this.orders = const [],
    this.selectedOrder,
    this.isLoading = false,
    this.error,
  });

  OrdersState copyWith({
    List<Order>? orders,
    Order? selectedOrder,
    bool? isLoading,
    String? error,
    bool clearSelectedOrder = false,
    bool clearError = false,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      selectedOrder: clearSelectedOrder ? null : selectedOrder ?? this.selectedOrder,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  factory OrdersState.initial() {
    return const OrdersState(
      orders: [],
      selectedOrder: null,
      isLoading: false,
      error: null,
    );
  }
}
