import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final String? selectedColor;
  final Function(Color) onColorSelected;

  const ColorSelector({
    Key? key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.textPrimary;
    final borderColor = colorScheme.outline;

    return Row(
      children: [
        Text(
          "Color",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(width: 16),
        ...colors.map((color) {
          final isSelected = selectedColor == color.toString();
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 0.8,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

