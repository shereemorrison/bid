import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class OrderPaymentOption extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const OrderPaymentOption({
    super.key,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Theme.of(context).colorScheme.cardBackground,
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.accent : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.accent
              : Theme.of(context).colorScheme.textSecondary,
        ),
      ),
    );
  }
}

