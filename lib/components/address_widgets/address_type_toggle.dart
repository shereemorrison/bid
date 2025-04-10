import 'package:flutter/material.dart';

class AddressTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const AddressTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildAddressTypeChip(context, 'shipping', 'Shipping'),
            const SizedBox(width: 12),
            _buildAddressTypeChip(context, 'billing', 'Billing'),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressTypeChip(BuildContext context, String type, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => onTypeSelected(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
