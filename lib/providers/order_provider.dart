import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<Order>? _orders;
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _error;

  List<Order>? get orders => _orders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserOrders(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ordersData = await _orderService.getUserOrders(userId);
      print('Orders data received: ${ordersData.length} orders');
      _orders = ordersData.map((order) => Order.fromJson(order)).toList();
    } catch (e) {
      _error = 'Failed to load orders: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final orderData = await _orderService.getOrderDetails(orderId);
      if (orderData != null) {
        _selectedOrder = Order.fromJson(orderData);
      } else {
        _error = 'Order not found';
      }
    } catch (e) {
      _error = 'Failed to load order details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }
}