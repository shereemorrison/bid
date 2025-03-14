import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../widgets/category_item.dart';

class CategoryListView extends StatefulWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;

  const CategoryListView({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 300,
      color: Colors.black,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = category.id == _selectedCategoryId;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryId = category.id;
              });
              widget.onCategorySelected(category);
            },
            child: CategoryItem(
              category: category,
              isSelected: isSelected, onTap: () { },
            ),
          );
        },
      ),
    );
  }
}