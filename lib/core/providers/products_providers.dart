import 'package:bid/core/providers/infrastructure_providers.dart';
import 'package:bid/models/category_model.dart' as app_category;
import 'package:bid/models/product_model.dart';
import 'package:bid/state/products/products_notifier.dart';
import 'package:bid/state/products/products_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(
    catalog: ref.watch(productRepositoryProvider),
  );
});

final categoriesProvider = Provider<List<app_category.Category>>((ref) {
  return ref.watch(productsProvider).categories;
});

final featuredProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).featuredProducts;
});

final collectionPreviewProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).collectionPreviewProducts;
});

final mostWantedProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).mostWantedProducts;
});

final allProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).products;
});

final selectedCategoryProvider = Provider<app_category.Category?>((ref) {
  return ref.watch(productsProvider).selectedCategory;
});

final productsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(productsProvider).isLoading;
});

final productsErrorProvider = Provider<String?>((ref) {
  return ref.watch(productsProvider).error;
});
