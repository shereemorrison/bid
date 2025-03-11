import 'package:bid/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation

class PaymentScreen extends StatelessWidget {
  final double totalAmount;

  PaymentScreen({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 20),
            MyButton(
              text: 'Pay Now',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (buildContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      title: Text('Payment Successful'),
                      content: Text(
                        'Your payment has been successfully processed',
                        style: TextStyle(color: Theme.of(context).colorScheme.surface),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
                            context.go('/profile_page'); // Navigate to the profile page
                          },
                          child: Text(
                            'Ok',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
