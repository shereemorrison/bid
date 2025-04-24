import 'package:bid/respositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'orders_state.dart';
import 'package:bid/models/order_model.dart';

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRepository _orderRepository;

  OrdersNotifier({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrdersState.initial());

  Future<void> fetchUserOrders(String authId) async {
    print('OrdersNotifier: Fetching orders for auth ID $authId');
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // First, inspect the database to understand what we're working with
      await _orderRepository.inspectDatabase();

      // Get raw order data
      final rawOrders = await _orderRepository.getUserOrders(authId);
      print('OrdersNotifier: Found ${rawOrders.length} raw orders');

      if (rawOrders.isEmpty) {
        print('OrdersNotifier: No orders found for auth ID $authId');
        state = state.copyWith(
          orders: [],
          isLoading: false,
        );
        return;
      }

      // Convert raw orders to Order objects
      final orders = rawOrders.map((orderData) {
        try {
          print('OrdersNotifier: Converting order ${orderData['order_id']}');
          return Order.fromJson(orderData);
        } catch (e) {
          print('OrdersNotifier: Error converting order: $e');
          return null;
        }
      }).where((order) => order != null).cast<Order>().toList();

      print('OrdersNotifier: Successfully converted ${orders.length} orders');

      state = state.copyWith(
        orders: orders,
        isLoading: false,
      );
    } catch (e) {
      print('OrdersNotifier: Error fetching orders: $e');
      state = state.copyWith(
        error: 'Failed to fetch orders: $e',
        isLoading: false,
      );
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // Get detailed order data including items
      final orderData = await _orderRepository.getOrderDetails(orderId);

      if (orderData != null) {
        try {
          final order = Order.fromJson(orderData);
          state = state.copyWith(
            selectedOrder: order,
            isLoading: false,
          );
        } catch (e) {
          print('OrdersNotifier: Error parsing order details: $e');
          state = state.copyWith(
            error: 'Failed to parse order details: $e',
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          error: 'Order not found',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch order details: $e',
        isLoading: false,
      );
    }
  }

  Future<bool> initiateReturn(String orderId, List<String> itemIds) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final success = await _orderRepository.initiateReturn(orderId, itemIds);

      if (success) {
        // Refresh order details
        await fetchOrderDetails(orderId);
        return true;
      } else {
        state = state.copyWith(
          error: 'Failed to initiate return',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Error initiating return: $e',
        isLoading: false,
      );
      return false;
    }
  }

  void clearSelectedOrder() {
    state = state.copyWith(clearSelectedOrder: true);
  }
}
