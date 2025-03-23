import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class OrderInfoCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const OrderInfoCard({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isLightMode ? Colors.white : Theme.of(context).colorScheme.quaternary,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'Change',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

