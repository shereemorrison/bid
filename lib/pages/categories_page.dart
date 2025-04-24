
import 'package:bid/components/category_widgets/category_item.dart';
import 'package:bid/components/category_widgets/category_list.dart';
import 'package:bid/components/common_widgets/search_bar.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).loadInitialData();
    });
  }

  void _navigateToCategory(Category category) {
    final path = '/shop/${category.slug}';
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final isLoading = ref.watch(productsLoadingProvider);
    final error = ref.watch(productsErrorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              )
                  : error != null
                  ? Center(
                child: Text('Error: $error'),
              )
                  : CategoryListView(
                categories: categories,
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