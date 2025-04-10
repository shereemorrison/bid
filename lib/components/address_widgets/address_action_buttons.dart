
import 'package:bid/models/address_model.dart';
import 'package:flutter/material.dart';

class AddressActionButtons extends StatelessWidget {
  final AddressModel? selectedAddress;
  final Function(AddressModel?) onEditAddress;
  final Function() onAddNewAddress;

  const AddressActionButtons({
    Key? key,
    required this.selectedAddress,
    required this.onEditAddress,
    required this.onAddNewAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Edit address button
        Expanded(
          child: OutlinedButton(
            onPressed: () => onEditAddress(selectedAddress),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'EDIT ADDRESS',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Add new address button
        OutlinedButton(
          onPressed: onAddNewAddress,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorScheme.primary),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          child: Icon(Icons.add, color: colorScheme.primary),
        ),
      ],
    );
  }
}