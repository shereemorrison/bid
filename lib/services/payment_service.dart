import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Address;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/address_model.dart';
import '../respositories/payment_repository.dart';
import '../services/base_service.dart';
import '../state/cart/cart_state.dart';
import '../utils/order_calculator.dart';
import '../providers.dart';

class PaymentService extends BaseService {
  final Ref _ref;
  final PaymentRepository _paymentRepository;

  PaymentService(this._ref) : _paymentRepository = _ref.read(paymentRepositoryProvider);

  Future<Map<String, dynamic>> processPayment({
    required String cardHolderName,
    required CardFieldInputDetails cardDetails,
    required double amount,
    required Address shippingAddress,
  }) async {
    return handleServiceOperation(
      'processing payment',
          () async {
        if (!cardDetails.complete) {
          throw Exception('Please enter valid card details');
        }

        // Create payment intent
        final paymentIntentData = await _paymentRepository.createPaymentIntent(
          amount: amount,
          currency: 'aud',
        );

        final clientSecret = paymentIntentData['clientSecret'] as String;
        final paymentIntentId = paymentIntentData['id'] as String? ?? '';

        // Create payment method
        final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(
                name: cardHolderName,
              ),
            ),
          ),
        );

        // Confirm payment
        final paymentResult = await Stripe.instance.confirmPayment(
          paymentIntentClientSecret: clientSecret,
          data: PaymentMethodParams.cardFromMethodId(
            paymentMethodData: PaymentMethodDataCardFromMethod(
              paymentMethodId: paymentMethod.id,
            ),
          ),
          options: const PaymentMethodOptions(
            setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
          ),
        );

        final paymentSuccessful = paymentResult.status == PaymentIntentsStatus.Succeeded;

        if (paymentSuccessful) {
          // Create order
          final orderId = await _createOrder(paymentIntentId, shippingAddress);

          logServiceActivity('Payment successful', 'Order ID: $orderId');

          return {
            'success': true,
            'orderId': orderId,
            'paymentIntentId': paymentIntentId,
          };
        } else {
          throw Exception('Payment failed');
        }
      },
      defaultValue: {
        'success': false,
        'error': 'An unexpected error occurred',
      },
    );
  }

  Future<String> _createOrder(String paymentIntentId, Address shippingAddress) async {
    return handleServiceOperation(
      'creating order',
          () async {
        final cartState = _ref.read(cartProvider);
        final cartItems = cartState.items;

        // Calculate order totals
        final double subtotal = OrderCalculator.calculateProductSubtotal(
            cartItems.map((item) => item.product).toList()
        );
        final double shipping = 10.0;
        final double tax = OrderCalculator.calculateTax(subtotal);
        final double total = OrderCalculator.calculateTotal(
          subtotal: subtotal,
          taxAmount: tax,
          shippingAmount: shipping,
          discountAmount: 0.0,
        );

        // Create order in Supabase
        final orderData = {
          'user_id': shippingAddress.userId,
          'payment_intent_id': paymentIntentId,
          'status': 'PENDING',
          'subtotal': subtotal,
          'tax_amount': tax,
          'shipping_amount': shipping,
          'discount_amount': 0.0,
          'total_amount': total,
          'shipping_address_id': shippingAddress.id,
          'billing_address_id': shippingAddress.id,
          'shipping_method': 'Standard',
          'order_number': 'ORD-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'placed_at': DateTime.now().toIso8601String(),
        };

        // Insert the order and get the real UUID back
        final orderResult = await Supabase.instance.client
            .from('orders')
            .insert(orderData)
            .select('order_id')
            .single();

        final orderId = orderResult['order_id'];

        // Create order payment record
        await Supabase.instance.client
            .from('order_payments')
            .insert({
          'order_id': orderId,
          'payment_intent_id': paymentIntentId,
          'amount': total,
          'is_refund': false,
          'created_at': DateTime.now().toIso8601String(),
        });

        // Insert order items
        final orderItems = cartItems.map((item) => {
          'order_id': orderId,
          'product_id': item.productId,
          'variant_id': null,
          'product_name': item.name,
          'variant_name': item.selectedSize ?? 'Default',
          'sku': 'SKU-${item.productId.substring(0, 8)}',
          'quantity': item.quantity,
          'unit_price': item.price,
          'subtotal': item.price * item.quantity,
          'discount_amount': 0.0,
          'tax_amount': (item.price * item.quantity) * 0.1,
          'total': (item.price * item.quantity) * 1.1,
          'created_at': DateTime.now().toIso8601String(),
        }).toList();

        await Supabase.instance.client
            .from('order_items')
            .insert(orderItems);

        return orderId;
      },
      defaultValue: '',
      throwError: true, // We want to propagate errors here
    );
  }
}
