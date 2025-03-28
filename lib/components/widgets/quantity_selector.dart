import 'package:flutter/material.dart';
import '../buttons/shopping_buttons.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.primary;

    return Row(
      children: [
        CustomIconButton(
          icon: Icons.remove,
          onTap: onDecrement,
          iconColor: textColor,
          borderColor: textColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        CustomIconButton(
          icon: Icons.add,
          onTap: onIncrement,
          iconColor: textColor,
          borderColor: textColor,
        ),
      ],
    );
  }
}

