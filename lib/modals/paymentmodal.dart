import 'package:bid/components/my_button.dart';
import 'package:flutter/material.dart';

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
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            MyButton(
              text: 'Pay Now',
              onTap: () {
                showDialog(
                context: context,
                builder: (buildContext) {
                  return AlertDialog(
                      title: Text('Payment Successful'),
                      content: Text('Your payment has been successfully processed'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            },
                          child: Text('Ok',
                          style: TextStyle(
                              color: Colors.black,
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
