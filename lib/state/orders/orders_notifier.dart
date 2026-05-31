import 'package:bid/repositories/order_repository.dart';
import '../base/base_notifier.dart';
import 'orders_state.dart';
import 'package:bid/models/order_model.dart';

class OrdersNotifier extends BaseNotifier<OrdersState> {
  final OrderRepository _orderRepository;

  OrdersNotifier({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository,
        super(OrdersState.initial());

  Future<void> fetchUserOrders(String userId) async {
    print('OrdersNotifier: Fetching orders for user_id $userId');
    startLoading();

    try {
      final rawOrders = await _orderRepository.getUserOrders(userId);
      print('OrdersNotifier: Found ${rawOrders.length} raw orders');

      if (rawOrders.isEmpty) {
        print('OrdersNotifier: No orders found for user_id $userId');
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
    state = state.copyWith(clearSelectedOrder: true, clearError: true);

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

  void clearSelectedOrder() {
    state = state.copyWith(clearSelectedOrder: true);
  }

  void clearOrders() {
    state = OrdersState.initial();
    print('Orders state reset to initial');
  }
}
