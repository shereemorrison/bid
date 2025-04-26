import 'package:bid/components/address_widgets/address_selector.dart';
import 'package:bid/components/order_widgets/order_address_card.dart';
import 'package:flutter/material.dart';


class ShippingTabUIHelper {
  // Build shipping information section
  static Widget buildShippingInformation({
    required BuildContext context,
    required bool showAddressSelector,
    required dynamic selectedAddress,
    required Function(dynamic) onAddressSelected,
    required VoidCallback onAddressCardTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),

        if (showAddressSelector)
          AddressSelector(
            onAddressSelected: onAddressSelected,
          )
        else
          OrderAddressCard(
            address: selectedAddress,
            onTap: onAddressCardTap,
          ),
      ],
    );
  }

  // Build shipping method section
  static Widget buildShippingMethod(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),

        // Standard shipping option
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Standard Shipping',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Delivery in 3-5 business days',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                '\$10.00',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build bottom buttons
  static Widget buildBottomButtons({
    required BuildContext context,
    required VoidCallback onBack,
    required VoidCallback? onProceed,
    required bool canProceed,
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

        // Continue button
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: canProceed ? onProceed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text(
                'PAYMENT',
                style: TextStyle(
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
