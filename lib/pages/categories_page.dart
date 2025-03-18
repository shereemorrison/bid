import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../routes/route.dart';
import '../components/widgets/search_bar.dart';
import '../components/widgets/category_list.dart';
import '../components/widgets/category_item.dart';

@RoutePage()
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
    switch (category.name) {
      case 'Men':
        context.pushRoute(const ShopMenRoute());
        break;
      case 'Women':
        context.pushRoute(const ShopMenRoute());
        break;
      case 'Accessories':
        context.pushRoute(const ShopMenRoute());
        break;
      case 'New Arrivals':
        context.pushRoute(const ShopMenRoute());
        break;
      case 'On Sale':
        context.pushRoute(const ShopMenRoute());
        break;
      default:
        break;
    }
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
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
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

@RoutePage()
class CategoriesRootPage extends StatelessWidget {
  const CategoriesRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}