//
// import 'package:bid/components/buttons/shopping_buttons.dart';
// import 'package:bid/services/dialog_service.dart';
// import 'package:flutter/material.dart';
//
//
// class PaymentScreen extends StatelessWidget {
//   final double totalAmount;
//
//   const PaymentScreen({super.key, required this.totalAmount});
//
//   void _showPaymentSuccessDialog(BuildContext context) {
//     DialogService.showConfirmationDialog(
//       context: context,
//       title: "Payment Successful",
//       content: "Your payment has been successfully processed",
//       cancelText: "OK",
//       confirmText: "",
//       isDestructive: false,
//     ).then((_) {
//       Navigator.of(context, rootNavigator: true).pop();
//       // TO DO - ADD Navigate to the profile page
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       child: Container(
//         width: 600,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
//               style: TextStyle(
//                   fontSize: 24,
//                   color: Theme.of(context).colorScheme.primary
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Use the new button style
//             BaseStyledButton(
//               text: 'PAY NOW',
//               onTap: () => _showPaymentSuccessDialog(context),
//               width: 200,
//               height: 50,
//               fontSize: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }