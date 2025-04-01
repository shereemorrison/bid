
import 'package:bid/models/category_model.dart';
import 'package:flutter/material.dart';


enum CategoryItemStyle { grid, list, block }

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;
  final CategoryItemStyle style;

  const CategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.style = CategoryItemStyle.list,
  });

  @override
  Widget build(BuildContext context) {
    if (style == CategoryItemStyle.grid) {
      return _buildGridItem(context);
    } else if (style == CategoryItemStyle.block) {
      return _buildBlockItem(context);
    } else {
      return _buildListItem(context);
    }
  }

  Widget _buildGridItem(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: colorScheme.secondary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            category.name,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBlockItem(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 80,
        decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: isSelected
            ? Border.all(color: colorScheme.secondary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          // Left accent bar for selected items
          if (isSelected)
            Container(
              width: 4,
              color: colorScheme.secondary,
            ),

          // Category content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category name
                  Text(
                    category.name,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),

                  // Arrow icon
                  Icon(
                    Icons.arrow_forward,
                    color: isSelected
                        ? colorScheme.secondary
                        : Colors.grey.shade600,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
  Widget _buildListItem(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.surface,
      title: Text(
        category.name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
