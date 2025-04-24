import 'package:bid/respositories/category_repository.dart';
import 'package:bid/respositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_state.dart';

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  ProductsNotifier({
    required ProductRepository productRepository,
    required CategoryRepository categoryRepository,
  })  : _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        super(ProductsState.initial());

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, clearError: true);

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
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load initial data: $e',
        isLoading: false,
      );
    }
  }

  Future<void> loadAllProducts() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final products = await _productRepository.getAllProducts();

      state = state.copyWith(
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load products: $e',
        isLoading: false,
      );
    }
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final products = await _productRepository.getProductsByCategory(categoryId);
      final category = await _categoryRepository.getCategoryById(categoryId);

      state = state.copyWith(
        products: products,
        selectedCategory: category,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load products by category: $e',
        isLoading: false,
      );
    }
  }
  Future<void> loadProductsByCategorySlug(String slug) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final category = await _categoryRepository.getCategoryBySlug(slug);

      if (category != null) {
        // Use the RPC function instead of getProductsByCategory
        final products = await _productRepository.getProductsByCategorySlug(slug);

        state = state.copyWith(
          products: products,
          selectedCategory: category,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: 'Category not found',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load products by category slug: $e',
        isLoading: false,
      );
    }
  }

  Future<void> loadProductDetails(String productId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final product = await _productRepository.getProductDetails(productId);

      if (product != null) {
        state = state.copyWith(
          selectedProduct: product,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: 'Product not found',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load product details: $e',
        isLoading: false,
      );
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await loadAllProducts();
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final products = await _productRepository.searchProducts(query);

      state = state.copyWith(
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to search products: $e',
        isLoading: false,
      );
    }
  }

  void clearSelectedProduct() {
    state = state.copyWith(clearSelectedProduct: true);
  }

  void clearSelectedCategory() {
    state = state.copyWith(clearSelectedCategory: true);
  }
}
