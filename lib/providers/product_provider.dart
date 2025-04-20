// NEW FILE: lib/providers/product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/products_model.dart';
import '../services/product_service.dart';

// Service provider
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

// State providers
final productsProvider = StateProvider<List<Product>>((ref) => []);
final productLoadingProvider = StateProvider<bool>((ref) => false);
final productErrorProvider = StateProvider<String?>((ref) => null);

// Provider for products by category
final productsByCategoryProvider = StateProvider.family<List<Product>, String>((ref, categorySlug) => []);

// Controller notifier for complex state management
class ProductNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final ProductService _productService;

  ProductNotifier(this._ref, this._productService) : super(const AsyncValue.data(null));

  // Load products by category
  Future<void> loadProductsByCategory(String categorySlug) async {
    _ref.read(productLoadingProvider.notifier).state = true;
    _ref.read(productErrorProvider.notifier).state = null;

    try {
      final products = await _productService.getProductsByCategorySlug(categorySlug);
      _ref.read(productsByCategoryProvider(categorySlug).notifier).state = products;
    } catch (e) {
      _ref.read(productErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(productLoadingProvider.notifier).state = false;
    }
  }
}

// Provider for the product notifier
final productNotifierProvider = StateNotifierProvider<ProductNotifier, AsyncValue<void>>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductNotifier(ref, productService);
});
