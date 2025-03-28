
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hintColor = colorScheme.onSurface;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.secondary)),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Icon(
            Icons.search,
            color: hintColor,
          ),
          const SizedBox(width: 10),
          Text(
            'Search',
            style: TextStyle(
              color: hintColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}