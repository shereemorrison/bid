
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../components/widgets/search_bar.dart';
import '../components/widgets/category_list.dart';
import '../components/widgets/category_item.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading categories: $e');
    }
  }

  void _navigateToCategory(Category category) {
    final path = '/shop/${category.slug}';
    print('Navigating to: $path');
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomSearchBar(),
            ),
            // Category blocks list
            Expanded(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
                  : CategoryListView(
                categories: _categories,
                onCategorySelected: _navigateToCategory,
                style: CategoryItemStyle.block,
                maintainState: false, // No selection state for main navigation
              ),
            ),
          ],
        ),
      ),
    );
  }
}