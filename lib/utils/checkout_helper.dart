// import 'package:bid/components/checkout/custom_payment_form.dart';
// import 'package:bid/pages/checkout_page.dart' hide checkoutCompleteProvider;
// import 'package:bid/providers.dart';
// import 'package:bid/utils/order_calculator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// class PaymentServiceHelper {
//   // Validate payment inputs
//   static String? validatePaymentInputs({
//     required String name,
//     required String cardNumber,
//     required String expiry,
//     required String cvc,
//   }) {
//     if (name.isEmpty) {
//       return 'Please enter the name on the card';
//     }
//
//     if (cardNumber.isEmpty) {
//       return 'Please enter the card number';
//     }
//
//     if (expiry.isEmpty) {
//       return 'Please enter the expiry date';
//     }
//
//     if (cvc.isEmpty) {
//       return 'Please enter the CVC';
//     }
//
//     return null;
//   }
//
//   // Get payment method name
//   static String getPaymentMethodName(int selectedPaymentMethod) {
//     switch (selectedPaymentMethod) {
//       case 0:
//         return 'Credit Card';
//       case 1:
//         return 'New Payment Method';
//       case 2:
//         return 'Paypal';
//       default:
//         return 'Credit Card';
//     }
//   }
//
//   // Process payment
//   static Future<void> processPayment({
//     required BuildContext context,
//     required WidgetRef ref,
//     required int selectedPaymentMethod,
//     required String name,
//     required String cardNumber,
//     required String expiry,
//     required String cvc,
//     required Function(bool) setLoading,
//     required Function(String?) setErrorMessage,
//   }) async {
//     // Validate inputs
//     final errorMessage = validatePaymentInputs(
//       name: name,
//       cardNumber: cardNumber,
//       expiry: expiry,
//       cvc: cvc,
//     );
//
//     if (errorMessage != null) {
//       setErrorMessage(errorMessage);
//       return;
//     }
//
//     setLoading(true);
//     setErrorMessage(null);
//
//     try {
//       // Get necessary data for order creation
//       final cart = ref.read(cartProvider);
//       final selectedAddress = ref.read(effectiveAddressProvider);
//
//       // Check if user is logged in, but don't require it
//       final userRepository = ref.read(userRepositoryProvider);
//       final isLoggedIn = userRepository.isLoggedIn;
//       final userId = userRepository.currentUserId;
//
//       // Validate address and cart
//       if (selectedAddress == null) {
//         throw Exception('No shipping address selected');
//       }
//
//       if (cart.items.isEmpty) {
//         throw Exception('Cart is empty');
//       }
//
//       // Calculate order totals
//       final products = cart.items.map((item) => item.product).toList();
//       final double subtotal = OrderCalculator.calculateProductSubtotal(products);
//       final double shipping = 10.0;
//       final double tax = OrderCalculator.calculateTax(subtotal);
//       final double total = OrderCalculator.calculateTotal(
//         subtotal: subtotal,
//         taxAmount: tax,
//         shippingAmount: shipping,
//         discountAmount: 0.0,
//       );
//
//       // Simulate payment processing
//       await Future.delayed(const Duration(seconds: 2));
//
//       // Create order in Supabase using the enhanced OrderService
//       final orderRepository = ref.read(orderRepositoryProvider);
//
//       // Use the createOrderFromCheckout method with guest checkout support
//       final orderResult = await orderRepository.createOrderFromCheckout(
//         userId: isLoggedIn ? userId ?? 'guest' : 'guest',
//         products: cart.items,
//         shippingAddress: selectedAddress,
//         subtotal: subtotal,
//         tax: tax,
//         shipping: shipping,
//         total: total,
//         paymentMethod: getPaymentMethodName(selectedPaymentMethod),
//         paymentIntentId: 'sim_${DateTime.now().millisecondsSinceEpoch}',
//         isGuestCheckout: !isLoggedIn,
//       );
//
//       if (!orderResult['success']) {
//         throw Exception(orderResult['message']);
//       }
//
//       print('Order created successfully: ${orderResult['order_id']}');
//
//       // Update payment result state
//       ref.read(paymentResultProvider.notifier).state = 'Payment successful!';
//
//       // Clear the cart
//       ref.read(cartProvider.notifier).clearCart();
//
//       // Mark checkout as complete if you have a checkout provider
//       try {
//         ref.read(checkoutCompleteProvider.notifier).state = true;
//       } catch (e) {
//         print('Note: Checkout provider not available: $e');
//       }
//
//       // Navigate to success page with order ID - use go instead of push
//       GoRouter.of(context).go('/order-confirmation?order_id=${orderResult['order_id']}');
//     } catch (e) {
//       print('Payment error: $e');
//       setErrorMessage('Payment failed: ${e.toString()}');
//
//       // Update payment result state
//       ref.read(paymentResultProvider.notifier).state = 'Payment failed: ${e.toString()}';
//     } finally {
//       setLoading(false);
//     }
//   }
// }
