import 'package:bid/models/order_model.dart';
import 'package:bid/services/order_query_service.dart';
import 'package:bid/services/checkout_user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

/// Service responsible for creating orders and related records
class OrderCreatorService {
  final SupabaseClient _supabase;
  late final UserAddressService _userAddressService;

  OrderCreatorService(this._supabase) {
    _userAddressService = UserAddressService(_supabase);
  }

  // Generate a valid UUID
  String _generateUuid() {
    return const Uuid().v4();
  }

  // Create order from checkout
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
  }) async {
    try {
      // print('Creating order with parameters:');
      // print('- userId: $userId');
      // print('- isGuestCheckout: $isGuestCheckout');
      // print('- products count: ${products.length}');
      // print('- total: $total');
      if (paymentIntentId != null) {
        print('- paymentIntentId: $paymentIntentId');
      }

      // Step 1: Handle user and address
      final userResult = await _userAddressService.handleUserAndAddress(
        userId: userId,
        shippingAddress: shippingAddress,
        isGuestCheckout: isGuestCheckout,
      );

      // Step 2: Create order record
      final orderId = await _createOrderRecord(
        userIdForDb: userResult['userIdForDb'],
        shippingAddressId: userResult['shippingAddressId'],
        subtotal: subtotal,
        tax: tax,
        shipping: shipping,
        total: total,
        paymentIntentId: paymentIntentId, // Pass payment intent ID
      );

      // Step 3: Create payment record
      await _createPaymentRecord(orderId, total, paymentIntentId); // Pass payment intent ID

      // Step 4: Create order items
      await _createOrderItems(orderId, products);

      return {
        'success': true,
        'order_id': orderId,
        'message': 'Order created successfully'
      };
    } catch (e) {
      print('Error creating order: $e');
      return {
        'success': false,
        'message': 'Failed to create order: $e'
      };
    }
  }

  // Create order record
  Future<String> _createOrderRecord({
    required String userIdForDb,
    required String? shippingAddressId,
    required double subtotal,
    required double tax,
    required double shipping,
    required double total,
    String? paymentIntentId,
  }) async {
    print('Creating order record...');

    // Generate an order number (text format, not UUID)
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    final orderData = {
      'user_id': userIdForDb,
      'order_number': orderNumber, // Text format order number
      'subtotal': subtotal,
      'tax_amount': tax,
      'shipping_amount': shipping,
      'discount_amount': 0, // Required field
      'total_amount': total,
      'status': 'PENDING', // Text status
      'placed_at': DateTime.now().toIso8601String(),
      if (paymentIntentId != null) 'payment_intent_id': paymentIntentId, // Store payment intent ID if provided
    };

    // Add shipping address if available
    if (shippingAddressId != null) {
      orderData['shipping_address_id'] = shippingAddressId;
    }

    // print('Order data: $orderData');

    final orderResponse = await _supabase
        .from('orders')
        .insert(orderData)
        .select('order_id')
        .single();

    final orderId = orderResponse['order_id'];
    // print('Created order with ID: $orderId');
    return orderId;
  }

  // Create payment record
  Future<void> _createPaymentRecord(String orderId, double total, [String? paymentIntentId]) async {
    // print('Creating payment record...');

    // Generate a UUID for the payment_id and order_payment_id
    final paymentUuid = _generateUuid();
    final orderPaymentUuid = _generateUuid();

    // Create a payment record with UUID for payment_id
    final paymentData = {
      'order_payment_id': orderPaymentUuid,
      'order_id': orderId,
      'payment_id': paymentUuid, // Use UUID instead of string
      'amount': total,
      'is_refund': false,
      'created_at': DateTime.now().toIso8601String(),
      if (paymentIntentId != null) 'payment_intent_id': paymentIntentId, // Store payment intent ID if provided
    };

    await _supabase
        .from('order_payments')
        .insert(paymentData);

    // print('Created payment record for order');
  }

  // Create order items
  Future<void> _createOrderItems(String orderId, List<dynamic> products) async {
    // print('Creating order items...');
    for (var product in products) {
      try {
        // Generate UUID for order_item_id
        final orderItemId = _generateUuid();

        await _supabase
            .from('order_items')
            .insert({
          'order_item_id': orderItemId,
          'order_id': orderId,
          'product_id': product.id,
          'product_name': product.name,
          'quantity': product.quantity,
          'unit_price': product.price, // Use unit_price instead of price
          'subtotal': product.price * product.quantity,
          'discount_amount': 0, // Required field
          'tax_amount': (product.price * product.quantity) * 0.1, // Example tax calculation
          'total': product.price * product.quantity, // Total for this item
        });
        // print('Added item ${product.id} to order');
      } catch (e) {
        print('Error adding item ${product.id}: $e');
        // Continue with other items even if one fails
      }
    }
  }

  // Create order
  Future<Order> createOrder(Order order) async {
    try {
      // Generate an order number (text format, not UUID)
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      // Insert order
      final orderResponse = await _supabase
          .from('orders')
          .insert({
        'user_id': order.userId,
        'order_number': orderNumber, // Text format order number
        'status': order.status,
        'subtotal': order.subtotal,
        'tax_amount': order.taxAmount,
        'shipping_amount': order.shipping_amount,
        'discount_amount': 0, // Required field
        'total_amount': order.totalAmount,
      })
          .select()
          .single();

      final newOrderId = orderResponse['order_id'];

      // Insert order items
      for (var item in order.items) {
        await _supabase
            .from('order_items')
            .insert({
          'order_item_id': _generateUuid(),
          'order_id': newOrderId,
          'product_id': item.productId,
          'product_name': item.productName,
          'quantity': item.quantity,
          'unit_price': item.price,
          'subtotal': item.price * item.quantity,
          'discount_amount': 0,
          'tax_amount': (item.price * item.quantity) * 0.1,
          'total': item.price * item.quantity,
        });
      }

      // Return the created order with items
      final orderQueryService = OrderQueryService(_supabase);
      final newOrder = await orderQueryService.getOrderDetails(newOrderId);
      return Order.fromJson(newOrder!);
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }
}
