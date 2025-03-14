import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../components/widgets/category_block_item.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../routes/route.dart';
import '../components/widgets/search_bar.dart';
import '../components/widgets/category_block_list.dart';

@RoutePage()
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesScreenState();
}

  @override
  State<CategoriesPage> createState() => _CategoriesScreenState();

class _CategoriesScreenState extends State<CategoriesPage> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;

  final List<CategoryBlockItem> _categoryBlocks = [
    CategoryBlockItem(
      name: 'Men',
      icon: Icons.man,

    ),
    CategoryBlockItem(
      name: 'Women',
      icon: Icons.woman,
    ),
    CategoryBlockItem(
      name: 'Accessories',
      icon: Icons.shopping_bag_outlined,
    ),
    CategoryBlockItem(
      name: 'Featured',
      icon: Icons.favorite_outline_rounded,
    ),
    CategoryBlockItem(
      name: 'Sale',
      icon: Icons.currency_bitcoin,

    ),

  ];

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

  void _navigateToCategory(String categoryName) {
    switch (categoryName) {
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
      backgroundColor: Colors.black,
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
                  : CategoryBlockList(
                categories: _categoryBlocks,
                onCategorySelected: _navigateToCategory,
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