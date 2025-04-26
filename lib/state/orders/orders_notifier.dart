import 'package:bid/providers.dart';
import 'package:bid/respositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/base_notifier.dart';
import 'orders_state.dart';
import 'package:bid/models/order_model.dart';

class OrdersNotifier extends BaseNotifier<OrdersState> {
  final OrderRepository _orderRepository;
  final Ref _ref;

  OrdersNotifier({
    required OrderRepository orderRepository,
    required Ref ref,
  }) : _orderRepository = orderRepository,
        _ref = ref,
        super(OrdersState.initial());

  Future<void> fetchUserOrders(String authId) async {
    print('OrdersNotifier: Fetching orders for auth ID $authId');
    startLoading();

    try {
      // First, inspect the database to understand what we're working with
      await _orderRepository.inspectDatabase();

      // Get raw order data - pass the authId to the repository
      final rawOrders = await _orderRepository.getUserOrders(authId);
      print('OrdersNotifier: Found ${rawOrders.length} raw orders');

      if (rawOrders.isEmpty) {
        print('OrdersNotifier: No orders found for auth ID $authId');
        state = state.copyWith(
          orders: [],
        );
        endLoading();
        return;
      }

      // Convert raw orders to Order objects
      final orders = rawOrders.map((orderData) {
        try {
          print('OrdersNotifier: Converting order ${orderData['order_id']}');
          return Order.fromJson(orderData);
        } catch (e) {
          print('OrdersNotifier: Error converting order: $e');
          print('OrdersNotifier: Order data: $orderData');
          return null;
        }
      }).where((order) => order != null).cast<Order>().toList();

      print('OrdersNotifier: Successfully converted ${orders.length} orders');

      state = state.copyWith(
        orders: orders,
      );
      endLoading();
    } catch (e) {
      handleError('fetching orders', e);
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    startLoading();

    try {
      // Get detailed order data including items
      final orderData = await _orderRepository.getOrderDetails(orderId);

      if (orderData != null) {
        try {
          final order = Order.fromJson(orderData);
          state = state.copyWith(
            selectedOrder: order,
          );
          endLoading();
        } catch (e) {
          handleError('parsing order details', e);
        }
      } else {
        handleError('fetching order details', 'Order not found');
      }
    } catch (e) {
      handleError('fetching order details', e);
    }
  }

  Future<bool> initiateReturn(String orderId, List<String> itemIds) async {
    startLoading();

    try {
      final success = await _orderRepository.initiateReturn(orderId, itemIds);

      if (success) {
        // Refresh order details
        await fetchOrderDetails(orderId);
        return true;
      } else {
        handleError('initiating return', 'Failed to initiate return');
        return false;
      }
    } catch (e) {
      handleError('initiating return', e);
      return false;
    }
  }

  Future<void> fetchGuestOrdersByEmail(String email) async {
    startLoading();

    try {
      final guestOrderService = _ref.read(guestOrderServiceProvider);
      final guestOrders = await guestOrderService.getGuestOrdersByEmail(email);

      // Convert to Order objects and update state
      final orders = guestOrders.map((orderData) {
        try {
          return Order.fromJson(orderData);
        } catch (e) {
          print('Error converting guest order: $e');
          return null;
        }
      }).where((order) => order != null).cast<Order>().toList();

      state = state.copyWith(
        guestOrders: orders,
      );
      endLoading();
    } catch (e) {
      handleError('fetching guest orders', e);
    }
  }

  void clearSelectedOrder() {
    state = state.copyWith(clearSelectedOrder: true);
  }

  void clearOrders() {
    state = OrdersState.initial();
    print('Orders state reset to initial');
  }
}
