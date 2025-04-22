import 'package:bid/components/checkout/order_payment_option.dart';
import 'package:flutter/material.dart';

class PaymentTabUIHelper {
  // Build payment method options
  static Widget buildPaymentMethodOptions({
    required BuildContext context,
    required int selectedPaymentMethod,
    required Function(int) onPaymentMethodChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: OrderPaymentOption(
            icon: Icons.credit_card,
            isSelected: selectedPaymentMethod == 0,
            onTap: () => onPaymentMethodChanged(0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OrderPaymentOption(
            icon: Icons.add,
            isSelected: selectedPaymentMethod == 1,
            onTap: () => onPaymentMethodChanged(1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OrderPaymentOption(
            icon: Icons.person_outline,
            isSelected: selectedPaymentMethod == 2,
            onTap: () => onPaymentMethodChanged(2),
          ),
        ),
      ],
    );
  }

  // Build card input fields
  static Widget buildCardInputFields({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController cardNumberController,
    required TextEditingController expiryController,
    required TextEditingController cvcController,
  }) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name on card field
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name on Card',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
          ),
          style: TextStyle(color: colorScheme.primary),
        ),

        const SizedBox(height: 16),

        // Card number field
        TextField(
          controller: cardNumberController,
          decoration: InputDecoration(
            labelText: 'Card Number',
            hintText: '4242 4242 4242 4242',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
          ),
          keyboardType: TextInputType.number,
          style: TextStyle(color: colorScheme.primary),
        ),

        const SizedBox(height: 16),

        // Expiry and CVC fields in a row
        Row(
          children: [
            // Expiry date field
            Expanded(
              child: TextField(
                controller: expiryController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
                keyboardType: TextInputType.datetime,
                style: TextStyle(color: colorScheme.primary),
              ),
            ),

            const SizedBox(width: 16),

            // CVC field
            Expanded(
              child: TextField(
                controller: cvcController,
                decoration: InputDecoration(
                  labelText: 'CVC',
                  hintText: '123',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Test card info
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

  // Build bottom buttons
  static Widget buildBottomButtons

  (

      {

  required

  BuildContext

  context,
  required VoidCallback onBack,
  required VoidCallback? onPay,
  required bool isLoading,
  required double amount,
  required String formatPrice

  (

  double

  amount

  )

  ,
}) {
final colorScheme = Theme.of(context).colorScheme;

return Row(
children: [
// Back button
Expanded(
flex: 1,
child: SizedBox(
height: 50,
child: OutlinedButton(
onPressed: onBack,
style: OutlinedButton.styleFrom(
side: BorderSide(color: colorScheme.primary),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(0),
),
),
child: Text(
'BACK',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
color: colorScheme.primary,
letterSpacing: 1.0,
),
),
),
),
),

const SizedBox(width: 16),

// Pay button
Expanded(
flex: 2,
child: SizedBox(
height: 50,
child: ElevatedButton(
onPressed: onPay,
style: ElevatedButton.styleFrom(
backgroundColor: colorScheme.primary,
foregroundColor: colorScheme.onPrimary,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(0),
),
),
child: isLoading
? SizedBox(
height: 20,
width: 20,
child: CircularProgressIndicator(
strokeWidth: 2,
valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
),
)
    : Text(
'PAY ${formatPrice(amount)}',
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
letterSpacing: 1.0,
),
),
),
),
),
],
);
}
}
