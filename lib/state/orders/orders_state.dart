import 'package:bid/models/order_model.dart';
import 'package:flutter/foundation.dart';
import '../base/base_state.dart';

@immutable
class OrdersState extends BaseState {
  final List<Order> orders;
  final List<Order> guestOrders;
  final Order? selectedOrder;

  const OrdersState({
    this.orders = const [],
    this.guestOrders = const [],
    this.selectedOrder,
    bool isLoading = false,
    String? error,
  }) : super(isLoading: isLoading, error: error);

  @override
  OrdersState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return OrdersState(
      orders: orders,
      guestOrders: guestOrders,
      selectedOrder: selectedOrder,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  OrdersState copyWith({
    List<Order>? orders,
    List<Order>? guestOrders,
    Order? selectedOrder,
    bool? isLoading,
    String? error,
    bool clearSelectedOrder = false,
    bool clearError = false,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      guestOrders: guestOrders ?? this.guestOrders,
      selectedOrder: clearSelectedOrder ? null : selectedOrder ?? this.selectedOrder,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  factory OrdersState.initial() {
    return const OrdersState(
      orders: [],
      guestOrders: [],
      selectedOrder: null,
      isLoading: false,
      error: null,
    );
  }
}
