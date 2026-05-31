import 'package:bid/repositories/product_repository.dart';
import '../base/base_notifier.dart';
import 'products_state.dart';

class ProductsNotifier extends BaseNotifier<ProductsState> {
  final ProductRepository _catalog;

  ProductsNotifier({required ProductRepository catalog})
      : _catalog = catalog,
        super(ProductsState.initial());

  Future<void> loadInitialData() async {
    startLoading();

    try {
      final categories = await _catalog.getAllCategories();
      final featuredProducts = await _catalog.getFeaturedProducts();
      final collectionPreviewProducts =
          await _catalog.getCollectionPreviewProducts();
      final mostWantedProducts = await _catalog.getMostWantedProducts();

      state = state.copyWith(
        categories: categories,
        featuredProducts: featuredProducts,
        collectionPreviewProducts: collectionPreviewProducts,
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
      final products = await _catalog.getAllProducts();
      state = state.copyWith(products: products);
      endLoading();
    } catch (e) {
      handleError('loading products', e);
    }
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    startLoading();

    try {
      final products = await _catalog.getProductsByCategory(categoryId);
      final category = await _catalog.getCategoryById(categoryId);

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
      final category = await _catalog.getCategoryBySlug(slug);

      if (category != null) {
        final products = await _catalog.getProductsByCategorySlug(slug);
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
      final product = await _catalog.getProductDetails(productId);

      if (product != null) {
        state = state.copyWith(selectedProduct: product);
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
      final products = await _catalog.searchProducts(query);
      state = state.copyWith(products: products);
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
