import 'package:bid/core/providers/infrastructure_providers.dart';
import 'package:bid/models/order_model.dart';
import 'package:bid/state/orders/orders_notifier.dart';
import 'package:bid/state/orders/orders_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(
    orderRepository: ref.watch(orderRepositoryProvider),
  );
});

final userOrdersProvider = Provider<List<Order>>((ref) {
  return ref.watch(ordersProvider).orders;
});

final selectedOrderProvider = Provider<Order?>((ref) {
  return ref.watch(ordersProvider).selectedOrder;
});

final ordersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(ordersProvider).isLoading;
});

final ordersErrorProvider = Provider<String?>((ref) {
  return ref.watch(ordersProvider).error;
});
