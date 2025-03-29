import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final Function(String) onSizeSelected;

  const SizeSelector({
    Key? key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.primary;
    final backgroundColor = colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Size",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: sizes.map((size) {
            final isSelected = selectedSize == size;
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SizeButton(
                size: size,
                isSelected: isSelected,
                onTap: () => onSizeSelected(size),
                textColor: textColor,
                backgroundColor: backgroundColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SizeButton extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;
  final Color textColor;
  final Color backgroundColor;

  const SizeButton({
    Key? key,
    required this.size,
    required this.isSelected,
    required this.onTap,
    required this.textColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? textColor : Colors.transparent,
          border: Border.all(
            color: textColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? backgroundColor : textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

