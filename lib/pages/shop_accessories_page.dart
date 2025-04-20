
import 'package:bid/models/products_model.dart';
import 'package:bid/providers/product_provider.dart';
import 'package:bid/services/product_service.dart';
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
    ref.read(productNotifierProvider.notifier).loadProductsByCategory(categorySlug);
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsByCategoryProvider(categorySlug));
    final isLoading = ref.watch(productLoadingProvider);
    final error = ref.watch(productErrorProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: buildShopPageLayout(
          context,
          "Shop Accessories",
          products,
          isLoading,
          error,
              () => ref.read(productNotifierProvider.notifier).loadProductsByCategory(categorySlug)
      ),
    );
  }
}
