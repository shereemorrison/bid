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
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isLightMode ? Colors.white : Theme.of(context).colorScheme.quaternary,
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary.withOpacity(0.7),
        ),
      ),
    );
  }
}

