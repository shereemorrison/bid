
import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/page_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ShopAccessoriesPage extends ConsumerStatefulWidget {
  const ShopAccessoriesPage({super.key});

  @override
  ConsumerState<ShopAccessoriesPage> createState() => _ShopAccessoriesPageState();
}

class _ShopAccessoriesPageState extends ConsumerState<ShopAccessoriesPage> {
  final String categorySlug = 'accessories';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  void _loadProducts() {
    ref.read(productsProvider.notifier).loadProductsByCategorySlug(categorySlug);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final List<Product> products = (selectedCategory?.slug == categorySlug)
        ? ref.watch(allProductsProvider)
        : <Product>[];

    final isLoading = ref.watch(productsLoadingProvider);
    final error = ref.watch(productsErrorProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: buildShopPageLayout(
          context,
          "Shop Accessories",
          products,
          isLoading,
          error,
              () => ref.read(productsProvider.notifier).loadProductsByCategorySlug(categorySlug)
      ),
    );
  }
}
