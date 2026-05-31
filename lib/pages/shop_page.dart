import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/page_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShopPage extends ConsumerStatefulWidget {
  final String? categorySlug;
  
  const ShopPage({super.key, this.categorySlug});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  String? _categorySlug;

  @override
  void initState() {
    super.initState();
    // Get category from route or default to null (all products)
    _categorySlug = widget.categorySlug ?? 
                    GoRouterState.of(context).uri.queryParameters['category'];
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_categorySlug != null) {
        _loadProducts();
      }
    });
  }

  Future<void> _loadProducts() async {
    if (_categorySlug != null) {
      await ref.read(productsProvider.notifier).loadProductsByCategorySlug(_categorySlug!);
    }
  }

  String _getPageTitle() {
    switch (_categorySlug) {
      case 'men':
        return 'Shop Men';
      case 'women':
        return 'Shop Women';
      case 'accessories':
        return 'Shop Accessories';
      case 'sale':
        return 'Shop Sale';
      default:
        return 'Shop';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final List<Product> products = (_categorySlug != null && selectedCategory?.slug == _categorySlug)
        ? ref.watch(allProductsProvider)
        : <Product>[];

    final isLoading = ref.watch(productsLoadingProvider);
    final error = ref.watch(productsErrorProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: buildShopPageLayout(
        context,
        _getPageTitle(),
        products,
        isLoading,
        error,
        _loadProducts,
      ),
    );
  }
}
