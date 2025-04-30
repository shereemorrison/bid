// import 'package:bid/components/common_widgets/custom_textfield.dart';
// import 'package:bid/providers.dart';
// import 'package:bid/respositories/payment_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:go_router/go_router.dart';
//
// final paymentServiceProvider = riverpod.Provider<PaymentRepository>((ref) {
//   return ref.watch(paymentRepositoryProvider);
// });
//
// final paymentResultProvider = riverpod.StateProvider<String?>((ref) {
//   return null;
// });
//
// class CustomPaymentForm extends ConsumerStatefulWidget {
//   final double amount;
//
//   const CustomPaymentForm({
//     Key? key,
//     required this.amount,
//   }) : super(key: key);
//
//   @override
//   ConsumerState<CustomPaymentForm> createState() => _CustomPaymentFormState();
// }
//
// class _CustomPaymentFormState extends ConsumerState<CustomPaymentForm> {
//   CardFieldInputDetails? _cardFieldInputDetails;
//   bool _isLoading = false;
//   String? _errorMessage;
//   final TextEditingController _nameController = TextEditingController();
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       padding: const EdgeInsets.all(50.0),
//       // Form space - TODO - work out how big Stefan wants this
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Order summary
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Order Summary',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Total'),
//                     Text(
//                       '\$${widget.amount.toStringAsFixed(2)}',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Payment details title
//           const Text(
//             'Payment Details',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           MyTextField(
//             hintText: 'Name on Card',
//             obscureText: false,
//             controller: _nameController,
//           ),
//
//           const SizedBox(height: 10),
//
//           const Text(
//             'Card Information',
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.grey,
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           Container(
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: CardField(
//               onCardChanged: (details) {
//                 setState(() {
//                   _cardFieldInputDetails = details;
//                 });
//               },
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           // Helper text
//           const Text(
//             'For testing, use card number: 4242 4242 4242 4242, any future date, and any CVC',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // Error message (if any)
//           if (_errorMessage != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Text(
//                 _errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//
//           // Pay button
//           ElevatedButton(
//             onPressed: _cardFieldInputDetails?.complete == true && !_isLoading
//                 ? () => _handlePayment(context)
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20), // Match your custom style
//               ),
//             ),
//             child: _isLoading
//                 ? const SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//                 : Text(
//               'Pay \$${widget.amount.toStringAsFixed(2)}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Security note
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.lock, size: 16, color: Colors.grey),
//               SizedBox(width: 8),
//               Text(
//                 'Payments are secure and encrypted',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _handlePayment(BuildContext context) async {
//     final paymentService = ref.read(paymentServiceProvider);
//     final name = _nameController.text.trim();
//
//     if (name.isEmpty) {
//       setState(() {
//         _errorMessage = 'Please enter the name on the card';
//       });
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       print('Starting custom payment process for amount: ${widget.amount}');
//
//       // Create payment intent
//       final paymentIntentData = await paymentService.createPaymentIntent(
//         amount: widget.amount,
//         currency: 'usd',
//       );
//       print('Payment intent created: $paymentIntentData');
//
//       // Check if clientSecret exists
//       if (paymentIntentData['clientSecret'] == null) {
//         throw Exception('No client secret received from payment intent');
//       }
//
//       // Confirm payment with the card details
//       final paymentMethod = await Stripe.instance.createPaymentMethod(
//         params: PaymentMethodParams.card(
//           paymentMethodData: PaymentMethodData(
//             billingDetails: BillingDetails(
//               name: name,
//             ),
//           ),
//         ),
//       );
//
//       print('Payment method created: ${paymentMethod.id}');
//
//       // Confirm the payment
//       await Stripe.instance.confirmPayment(
//         paymentIntentClientSecret: paymentIntentData['clientSecret'],
//         data: PaymentMethodParams.card(
//           paymentMethodData: PaymentMethodData(
//             billingDetails: BillingDetails(
//               name: name,
//             ),
//           ),
//         ),
//       );
//
//       print('Payment confirmed successfully');
//
//       // Update payment result state
//       ref.read(paymentResultProvider.notifier).state = 'Payment successful!';
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Payment successful!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       // Navigate to success page
//       context.push('/order-confirmation');
//
//     } catch (e) {
//       print('Payment error: $e');
//
//       // Handle Stripe-specific exceptions
//       if (e is StripeException) {
//         setState(() {
//           _errorMessage = e.error.localizedMessage ?? 'Payment failed';
//         });
//         print('Stripe error code: ${e.error.code}');
//         print('Stripe error message: ${e.error.message}');
//       } else {
//         setState(() {
//           _errorMessage = 'Payment failed: ${e.toString()}';
//         });
//       }
//
//       // Update payment result state
//       ref.read(paymentResultProvider.notifier).state = 'Payment failed: ${e.toString()}';
//
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
