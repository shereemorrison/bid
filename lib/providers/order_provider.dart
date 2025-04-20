
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

// State providers
final ordersProvider = StateProvider<List<Order>?>((ref) => null);
final selectedOrderProvider = StateProvider<Order?>((ref) => null);
final orderLoadingProvider = StateProvider<bool>((ref) => false);
final orderErrorProvider = StateProvider<String?>((ref) => null);

// Order state notifier
class OrderNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final OrderService _orderService = OrderService();

  OrderNotifier(this._ref) : super(const AsyncValue.data(null));

  // Fetch user orders
  Future<void> fetchUserOrders(String userId) async {
    _ref.read(orderLoadingProvider.notifier).state = true;
    _ref.read(orderErrorProvider.notifier).state = null;

    try {
      // Get orders as Map<String, dynamic> and convert to Order objects
      final ordersData = await _orderService.getUserOrders(userId);
      final orders = ordersData.map((orderData) => Order.fromJson(orderData)).toList();
      _ref.read(ordersProvider.notifier).state = orders;
    } catch (e) {
      _ref.read(orderErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(orderLoadingProvider.notifier).state = false;
    }
  }

  // Fetch order details
  Future<void> fetchOrderDetails(String orderId) async {
    _ref.read(orderLoadingProvider.notifier).state = true;
    _ref.read(orderErrorProvider.notifier).state = null;

    try {
      // Get order details as Map<String, dynamic> and convert to Order
      final orderData = await _orderService.getOrderDetails(orderId);
      if (orderData != null) {
        final order = Order.fromJson(orderData);
        _ref.read(selectedOrderProvider.notifier).state = order;
      } else {
        _ref.read(selectedOrderProvider.notifier).state = null;
      }
    } catch (e) {
      _ref.read(orderErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(orderLoadingProvider.notifier).state = false;
    }
  }

  // Create a new order
  Future<void> createOrder(Order order) async {
    _ref.read(orderLoadingProvider.notifier).state = true;
    _ref.read(orderErrorProvider.notifier).state = null;

    try {
      // Create the order and get the result
      final newOrder = await _orderService.createOrder(order);

      // Update selected order
      _ref.read(selectedOrderProvider.notifier).state = newOrder;

      // Update orders list if it exists
      final currentOrders = _ref.read(ordersProvider);
      if (currentOrders != null) {
        _ref.read(ordersProvider.notifier).state = [...currentOrders, newOrder];
      }
    } catch (e) {
      _ref.read(orderErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(orderLoadingProvider.notifier).state = false;
    }
  }

  // Clear orders (e.g., on logout)
  void clearOrders() {
    _ref.read(ordersProvider.notifier).state = null;
    _ref.read(selectedOrderProvider.notifier).state = null;
    _ref.read(orderErrorProvider.notifier).state = null;
  }
}

// Provider for the order notifier
final orderNotifierProvider = StateNotifierProvider<OrderNotifier, AsyncValue<void>>((ref) {
  return OrderNotifier(ref);
});
