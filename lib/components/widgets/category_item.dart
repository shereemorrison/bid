import 'package:flutter/material.dart';
import '../../models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}