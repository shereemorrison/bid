/*import 'package:flutter/material.dart';
import '../../archive/category_block_item.dart';

class CategoryBlockList extends StatelessWidget {
  final List<CategoryBlockItem> categories;
  final Function(String) onCategorySelected;

  const CategoryBlockList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryBlock(
          category: category,
          onTap: () => onCategorySelected(category.name),
        );
      },
    );
  }
}
class CategoryBlock extends StatelessWidget {
  final CategoryBlockItem category;
  final VoidCallback onTap;

  const CategoryBlock({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100, // Increased height for better visual impact
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // Use image if available, otherwise fallback to color
          image: (category.imageAsset != null || category.imageUrl != null)
              ? DecorationImage(
            image: category.imageAsset != null
                ? AssetImage(category.imageAsset!)
                : NetworkImage(category.imageUrl!) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              color: Theme.of(context).colorScheme.primary,
              BlendMode.darken,
            ),
          )
              : null,
          color: category.imageAsset == null && category.imageUrl == null
              ? Colors.grey.shade900
              : null,
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    color: Theme.of(context).colorScheme.primary,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (category.subtitle.isNotEmpty)
                        Text(
                          category.subtitle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  const Icon(
                    Icons.favorite_border,
                    color: Theme.of(context).colorScheme.primary70,
                    size: 22,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/