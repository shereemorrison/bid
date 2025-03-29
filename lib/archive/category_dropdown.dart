
/*import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final List<String> categories;

  const CategoryDropdown({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cardBackground,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            category,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.textPrimary,
            ),
          ),
        )).toList(),
      ),
    );
  }
}*/