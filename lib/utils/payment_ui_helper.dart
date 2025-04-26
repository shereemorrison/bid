import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../utils/format_helpers.dart';
import '../utils/ui_helpers.dart';

class PaymentUIHelper {
  // Build order summary section
  static Widget buildOrderSummary(BuildContext context, double amount) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface == Colors.black
            ? Colors.grey[900]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          buildCostItem(
              context,
              'Total',
              formatPrice(amount),
              isTotal: true
          ),
        ],
      ),
    );
  }

  // Build card input field - fixed type for onCardChanged
  static Widget buildCardInputField(
      BuildContext context,
      Function(CardFieldInputDetails?) onCardChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Information',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CardField(
            onCardChanged: onCardChanged,
          ),
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

  // Build security note
  static Widget buildSecurityNote() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock, size: 16, color: Colors.grey),
        SizedBox(width: 8),
        Text(
          'Payments are secure and encrypted',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Build payment buttons
  static Widget buildPaymentButtons(
      BuildContext context, {
        required VoidCallback onBack,
        required VoidCallback? onPay,
        required bool isLoading,
        required double amount,
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
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.primary,
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
                'Pay ${formatPrice(amount)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
