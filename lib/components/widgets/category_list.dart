import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../widgets/category_item.dart';

class CategoryListView extends StatefulWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;
  final CategoryItemStyle style;
  final String? initialSelectedId;
  final bool maintainState;
  final Axis scrollDirection;

  const CategoryListView({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.style = CategoryItemStyle.list,
    this.initialSelectedId,
    this.maintainState = true,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialSelectedId;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: widget.scrollDirection,
        padding:  const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = widget.maintainState && category.id == _selectedCategoryId;

          return CategoryItem(
              category: category,
              isSelected: isSelected,
            style: widget.style,
            onTap: () {
              if (widget.maintainState) {
                setState(() {
                  _selectedCategoryId = category.id;
                });
              }
              widget.onCategorySelected(category);
            },
          );
        },
    );
  }
}