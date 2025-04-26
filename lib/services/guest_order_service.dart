import 'package:bid/models/address_model.dart';
import 'package:bid/respositories/address_repository.dart';
import 'package:bid/respositories/order_repository.dart';
import 'package:bid/respositories/user_repository.dart';
import 'package:bid/services/base_service.dart';
import 'package:bid/state/cart/cart_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class GuestOrderService extends BaseService {
  final UserRepository _userRepository;
  final AddressRepository _addressRepository;
  final OrderRepository _orderRepository;

  GuestOrderService({
    required UserRepository userRepository,
    required AddressRepository addressRepository,
    required OrderRepository orderRepository,
  })  : _userRepository = userRepository,
        _addressRepository = addressRepository,
        _orderRepository = orderRepository;

  // Save a guest order to local storage
  Future<Map<String, dynamic>> saveGuestOrder({
    required List<CartItem> items,
    required Address shippingAddress,
    required double subtotal,
    required double tax,
    required double shipping,
    required double total,
    required String paymentMethod,
    String? paymentIntentId,
  }) async {
    return handleServiceOperation(
      'saving guest order',
          () async {
        final prefs = await SharedPreferences.getInstance();

        // Generate a unique order ID
        final orderId = const Uuid().v4();

        // Create order data
        final orderData = {
          'order_id': orderId,
          'guest_id': shippingAddress.userId.startsWith('guest-')
              ? shippingAddress.userId.substring(6)
              : shippingAddress.userId,
          'items': items.map((item) => item.toJson()).toList(),
          'shipping_address': shippingAddress.toJson(),
          'subtotal': subtotal,
          'tax_amount': tax,
          'shipping_amount': shipping,
          'total_amount': total,
          'payment_method': paymentMethod,
          'payment_intent_id': paymentIntentId,
          'status': 'PENDING',
          'created_at': DateTime.now().toIso8601String(),
          'is_converted': false,
        };

        // Save to local storage
        final guestOrders = prefs.getStringList('guest_orders') ?? [];
        guestOrders.add(jsonEncode(orderData));
        await prefs.setStringList('guest_orders', guestOrders);

        logServiceActivity('Order saved', 'ID: $orderId');

        return {
          'success': true,
          'order_id': orderId,
          'message': 'Order saved successfully',
        };
      },
      defaultValue: <String, dynamic>{
        'success': false,
        'message': 'Failed to save order',
      },
    );
  }

  // Get a guest order by ID
  Future<Map<String, dynamic>?> getGuestOrder(String orderId) async {
    return handleServiceOperation(
      'getting guest order',
          () async {
        final prefs = await SharedPreferences.getInstance();
        final guestOrders = prefs.getStringList('guest_orders') ?? [];

        for (final orderJson in guestOrders) {
          final orderData = jsonDecode(orderJson) as Map<String, dynamic>;
          if (orderData['order_id'] == orderId) {
            return orderData;
          }
        }

        return null;
      },
      defaultValue: null,
    );
  }

  // Convert a guest order to a user order
  Future<bool> convertGuestOrderToUserOrder(String orderId, String userId) async {
    return handleServiceOperation(
      'converting guest order',
          () async {
        final prefs = await SharedPreferences.getInstance();
        final guestOrders = prefs.getStringList('guest_orders') ?? [];
        final updatedOrders = <String>[];
        bool found = false;

        for (final orderJson in guestOrders) {
          final orderData = jsonDecode(orderJson) as Map<String, dynamic>;
          if (orderData['order_id'] == orderId) {
            // Mark as converted
            orderData['is_converted'] = true;
            orderData['user_id'] = userId;
            found = true;
          }
          updatedOrders.add(jsonEncode(orderData));
        }

        if (found) {
          await prefs.setStringList('guest_orders', updatedOrders);
          logServiceActivity('Order converted', 'ID: $orderId, User: $userId');
          return true;
        }

        return false;
      },
      defaultValue: false,
    );
  }

  // Get all guest orders for a guest ID
  Future<List<Map<String, dynamic>>> getGuestOrders(String guestId) async {
    return handleServiceOperation(
      'getting guest orders',
          () async {
        final prefs = await SharedPreferences.getInstance();
        final guestOrders = prefs.getStringList('guest_orders') ?? [];
        final result = <Map<String, dynamic>>[];

        for (final orderJson in guestOrders) {
          final orderData = jsonDecode(orderJson) as Map<String, dynamic>;
          if (orderData['guest_id'] == guestId && !orderData['is_converted']) {
            result.add(orderData);
          }
        }

        logServiceActivity('Retrieved guest orders', 'Count: ${result.length}');
        return result;
      },
      defaultValue: <Map<String, dynamic>>[],
    );
  }

  // Get guest orders by email
  Future<List<Map<String, dynamic>>> getGuestOrdersByEmail(String email) async {
    return handleServiceOperation(
      'getting guest orders by email',
          () async {
        final prefs = await SharedPreferences.getInstance();
        final guestOrders = prefs.getStringList('guest_orders') ?? [];
        final result = <Map<String, dynamic>>[];

        for (final orderJson in guestOrders) {
          final orderData = jsonDecode(orderJson) as Map<String, dynamic>;
          final shippingAddress = orderData['shipping_address'] as Map<String, dynamic>?;

          if (shippingAddress != null &&
              shippingAddress['email'] == email &&
              !orderData['is_converted']) {
            result.add(orderData);
          }
        }

        logServiceActivity('Retrieved guest orders by email', 'Email: $email, Count: ${result.length}');
        return result;
      },
      defaultValue: <Map<String, dynamic>>[],
    );
  }
}
