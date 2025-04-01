
import 'package:bid/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(Category) onCategorySelected;

  const CategoryChips({
    Key? key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}