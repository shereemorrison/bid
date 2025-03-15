import 'package:flutter/material.dart';
import '../../models/category_model.dart';

enum CategoryItemStyle {
  block,  // Large image block style
  list,   // Simple text list style
}

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;
  final CategoryItemStyle style;

  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
    this.style = CategoryItemStyle.list
  });

  @override
  Widget build(BuildContext context) {
    return style == CategoryItemStyle.block
        ? _buildBlockStyle()
        : _buildListStyle();
  }

  Widget _buildListStyle() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: isSelected
                ? BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }


  Widget _buildBlockStyle() {
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
              Colors.black,
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
                    Colors.black,
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
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (category.subtitle != null &&
                          category.subtitle!.isNotEmpty)
                        Text(
                          category.subtitle!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  const Icon(
                    Icons.favorite_border,
                    color: Colors.white70,
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
