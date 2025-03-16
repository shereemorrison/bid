import 'package:flutter/material.dart';
import '../../models/category_model.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            category.name,
            style: const TextStyle(
              color: Colors.white,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade900,
        ),
        child: Stack(
          children: [
            // Category name
            Positioned(
              left: 20,
              bottom: 20,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Arrow icon
            Positioned(
              right: 20,
              bottom: 20,
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
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
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
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
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }
}
