import 'package:bid/utils/payment_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class SimplePaymentForm extends StatefulWidget {
  final TextEditingController cardHolderNameController;
  final ValueChanged<CardFieldInputDetails?> onCardChanged;

  const SimplePaymentForm({
    Key? key,
    required this.cardHolderNameController,
    required this.onCardChanged,
  }) : super(key: key);

  @override
  State<SimplePaymentForm> createState() => _SimplePaymentFormState();
}

class _SimplePaymentFormState extends State<SimplePaymentForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.cardHolderNameController,
            decoration: const InputDecoration(
              labelText: 'Name on Card',
              hintText: 'John Doe',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          PaymentUIHelper.buildCardInputField(
            context,
            widget.onCardChanged,
          ),
          const SizedBox(height: 16),
          PaymentUIHelper.buildSecurityNote(),
        ],
      ),
    );
  }
}
