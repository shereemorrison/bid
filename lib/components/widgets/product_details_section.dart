import 'package:flutter/material.dart';

class ProductDetailsSection extends StatelessWidget {
  final String title;
  final String description;

  const ProductDetailsSection({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customBeige = Theme.of(context).colorScheme.secondary;
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final textColor = isLightMode ? Colors.black : customBeige;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

