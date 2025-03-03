import 'package:bid/components/my_button.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;

  PaymentScreen({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            MyButton(text: 'Pay Now',
              onTap: (){ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment Successful!'
                  //add logic to navigate to order summary

                  )
                  )
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}
