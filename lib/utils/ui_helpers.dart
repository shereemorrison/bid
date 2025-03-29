import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

// Remove underscore to make it public
Widget buildAttributeTag(String text, BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    decoration: BoxDecoration(
      // Make sure this property exists in your ColorScheme extension
      // If not, use colorScheme.outline instead
      border: Border.all(color: colorScheme.outline),
      borderRadius: BorderRadius.circular(0),
    ),
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: colorScheme.textSecondary,
      ),
    ),
  );
}

// Helper for building cost items in OrderCostSummary
Widget buildCostItem(BuildContext context, String label, String value, {bool isTotal = false}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.textPrimary,
          fontSize: isTotal ? 16 : 14,
          fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.textPrimary,
          fontSize: isTotal ? 16 : 14,
          fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    ],
  );
}

// Helper for building info items in account page
Widget buildInfoItem(BuildContext context, String label, String value) {
  final colorScheme = Theme.of(context).colorScheme;

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: colorScheme.secondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 14,
              color: colorScheme.primary
          ),
        ),
      ],
    ),
  );
}

// Helper for building category chips
Widget buildCategoryChip(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
  final colorScheme = Theme.of(context).colorScheme;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.surface,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? colorScheme.onPrimary
              : colorScheme.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ),
  );
}

