import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:flutter/material.dart';


class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double size;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.size = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          icon: Icons.remove,
          onTap: onDecrement,
          iconColor: textColor,
          borderColor: textColor,
          size: size,
          iconSize: size * 0.6,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size * 0.3),
          child: Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: size * 0.6,
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
          size: size,
          iconSize: size * 0.6,
        ),
      ],
    );
  }
}

