import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentUIHelper {
  static Widget buildCardInputField(
    BuildContext context,
    Function(CardFieldInputDetails?) onCardChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Information',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CardField(onCardChanged: onCardChanged),
        ),
        const SizedBox(height: 8),
        const Text(
          'For testing, use card number: 4242 4242 4242 4242, any future date, and any CVC',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  static Widget buildSecurityNote() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock, size: 16, color: Colors.grey),
        SizedBox(width: 8),
        Text(
          'Payments are secure and encrypted',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
