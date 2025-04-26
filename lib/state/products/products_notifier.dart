import 'package:bid/respositories/category_repository.dart';
import 'package:bid/respositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/base_notifier.dart';
import 'products_state.dart';

class ProductsNotifier extends BaseNotifier<ProductsState> {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  ProductsNotifier({
    required ProductRepository productRepository,
    required CategoryRepository categoryRepository,
  })  : _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        super(ProductsState.initial());

  Future<void> loadInitialData() async {
    startLoading();

    try {
      // Load categories
      final categories = await _categoryRepository.getAllCategories();

      // Load featured products
      final featuredProducts = await _productRepository.getFeaturedProducts();

      // Load most wanted products
      final mostWantedProducts = await _productRepository.getMostWantedProducts();

      state = state.copyWith(
        categories: categories,
        featuredProducts: featuredProducts,
        mostWantedProducts: mostWantedProducts,
      );
      endLoading();
    } catch (e) {
      handleError('loading initial data', e);
    }
  }

  Future<void> loadAllProducts() async {
    startLoading();

    try {
      final products = await _productRepository.getAllProducts();

      state = state.copyWith(
        products: products,
      );
      endLoading();
    } catch (e) {
      handleError('loading products', e);
    }
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    startLoading();

    try {
      final products = await _productRepository.getProductsByCategory(categoryId);
      final category = await _categoryRepository.getCategoryById(categoryId);

      state = state.copyWith(
        products: products,
        selectedCategory: category,
      );
      endLoading();
    } catch (e) {
      handleError('loading products by category', e);
    }
  }

  Future<void> loadProductsByCategorySlug(String slug) async {
    startLoading();

    try {
      final category = await _categoryRepository.getCategoryBySlug(slug);

      if (category != null) {
        final products = await _productRepository.getProductsByCategorySlug(slug);

        state = state.copyWith(
          products: products,
          selectedCategory: category,
        );
        endLoading();
      } else {
        handleError('loading products by category slug', 'Category not found');
      }
    } catch (e) {
      handleError('loading products by category slug', e);
    }
  }

  Future<void> loadProductDetails(String productId) async {
    startLoading();

    try {
      final product = await _productRepository.getProductDetails(productId);

      if (product != null) {
        state = state.copyWith(
          selectedProduct: product,
        );
        endLoading();
      } else {
        handleError('loading product details', 'Product not found');
      }
    } catch (e) {
      handleError('loading product details', e);
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await loadAllProducts();
      return;
    }

    startLoading();

    try {
      final products = await _productRepository.searchProducts(query);

      state = state.copyWith(
        products: products,
      );
      endLoading();
    } catch (e) {
      handleError('searching products', e);
    }
  }

  void clearSelectedProduct() {
    state = state.copyWith(clearSelectedProduct: true);
  }

  void clearSelectedCategory() {
    state = state.copyWith(clearSelectedCategory: true);
  }
}
