
import 'package:bid/providers/product_provider.dart';
import 'package:bid/utils/page_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ShopMenPage extends ConsumerStatefulWidget {
  const ShopMenPage({super.key});

  @override
  ConsumerState<ShopMenPage> createState() => _ShopMenPageState();
}

class _ShopMenPageState extends ConsumerState<ShopMenPage> {
  final String categorySlug = 'men';

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
          "Shop Men",
          products,
          isLoading,
          error,
              () => ref.read(productNotifierProvider.notifier).loadProductsByCategory(categorySlug)
      ),
    );
  }
}

