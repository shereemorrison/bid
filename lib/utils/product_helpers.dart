import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

// Helper for building product cards in grids
Widget buildProductCard(
    BuildContext context,
    String title,
    String price,
    String imageUrl,
    VoidCallback onTap,
    ) {
  final colorScheme = Theme.of(context).colorScheme;

  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: colorScheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          price,
          style: TextStyle(
            color: colorScheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

