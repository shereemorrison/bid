import 'package:bid/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/checkout_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/address_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/order_service.dart';
import '../../utils/order_calculator.dart';

class PaymentServiceHelper {
  // Validate payment inputs
  static String? validatePaymentInputs({
    required String name,
    required String cardNumber,
    required String expiry,
    required String cvc,
  }) {
    if (name.isEmpty) {
      return 'Please enter the name on the card';
    }

    if (cardNumber.isEmpty) {
      return 'Please enter the card number';
    }

    if (expiry.isEmpty) {
      return 'Please enter the expiry date';
    }

    if (cvc.isEmpty) {
      return 'Please enter the CVC';
    }

    return null;
  }

  // Get payment method name
  static String getPaymentMethodName(int selectedPaymentMethod) {
    switch (selectedPaymentMethod) {
      case 0:
        return 'Credit Card';
      case 1:
        return 'New Payment Method';
      case 2:
        return 'Paypal';
      default:
        return 'Credit Card';
    }
  }

  // Process payment
  static Future<void> processPayment({
    required BuildContext context,
    required WidgetRef ref,
    required int selectedPaymentMethod,
    required String name,
    required String cardNumber,
    required String expiry,
    required String cvc,
    required Function(bool) setLoading,
    required Function(String?) setErrorMessage,
  }) async {
    // Validate inputs
    final errorMessage = validatePaymentInputs(
      name: name,
      cardNumber: cardNumber,
      expiry: expiry,
      cvc: cvc,
    );

    if (errorMessage != null) {
      setErrorMessage(errorMessage);
      return;
    }

    setLoading(true);
    setErrorMessage(null);

    try {
      // Get necessary data for order creation
      final cart = ref.read(cartProvider);
      final selectedAddress = ref.read(effectiveAddressProvider);

      // Check if user is logged in, but don't require it
      final userData = ref.read(userDataProvider);
      final isLoggedIn = userData != null;

      // Validate address and cart
      if (selectedAddress == null) {
        throw Exception('No shipping address selected');
      }

      if (cart.isEmpty) {
        throw Exception('Cart is empty');
      }

      // Calculate order totals
      final double subtotal = OrderCalculator.calculateProductSubtotal(cart);
      final double shipping = 10.0;
      final double tax = OrderCalculator.calculateTax(subtotal);
      final double total = OrderCalculator.calculateTotal(
        subtotal: subtotal,
        taxAmount: tax,
        shippingAmount: shipping,
        discountAmount: 0.0,
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Create order in Supabase using the enhanced OrderService
      final orderService = ref.read(orderServiceProvider);

      // Use the createOrderFromCheckout method with guest checkout support
      final orderResult = await orderService.createOrderFromCheckout(
        userId: isLoggedIn ? userData.userId : 'guest',
        products: cart,
        shippingAddress: selectedAddress,
        subtotal: subtotal,
        tax: tax,
        shipping: shipping,
        total: total,
        paymentMethod: getPaymentMethodName(selectedPaymentMethod),
        paymentIntentId: 'sim_${DateTime.now().millisecondsSinceEpoch}',
        isGuestCheckout: !isLoggedIn,
      );

      if (!orderResult['success']) {
        throw Exception(orderResult['message']);
      }

      print('Order created successfully: ${orderResult['order_id']}');

      // Update payment result state
      ref.read(paymentResultProvider.notifier).state = 'Payment successful!';

      // Clear the cart - use update method for safety
      ref.read(cartProvider.notifier).update((state) => []);

      // Mark checkout as complete if you have a checkout provider
      try {
        ref.read(checkoutCompleteProvider.notifier).state = true;
      } catch (e) {
        print('Note: Checkout provider not available: $e');
      }

      // Navigate to success page with order ID - use go instead of push
      // This replaces the current screen instead of adding to the stack
      GoRouter.of(context).go('/order-confirmation?order_id=${orderResult['order_id']}');
    } catch (e) {
      print('Payment error: $e');
      setErrorMessage('Payment failed: ${e.toString()}');

      // Update payment result state
      ref.read(paymentResultProvider.notifier).state = 'Payment failed: ${e.toString()}';
    } finally {
      setLoading(false);
    }
  }
}
