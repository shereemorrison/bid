import 'package:flutter/material.dart';

class OrderPaymentOption extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const OrderPaymentOption({
    Key? key,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? colorScheme.primary : Colors.grey,
            size: 28,
          ),
        ),
      ),
    );
  }
}
