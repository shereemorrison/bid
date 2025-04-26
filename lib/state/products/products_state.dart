import 'package:bid/models/category_model.dart' as app_category;
import 'package:bid/models/product_model.dart';
import 'package:flutter/foundation.dart';
import '../base/base_state.dart';

@immutable
class ProductsState extends BaseState {
  final List<Product> products;
  final List<Product> featuredProducts;
  final List<Product> mostWantedProducts;
  final List<app_category.Category> categories;
  final Product? selectedProduct;
  final app_category.Category? selectedCategory;

  const ProductsState({
    this.products = const [],
    this.featuredProducts = const [],
    this.mostWantedProducts = const [],
    this.categories = const [],
    this.selectedProduct,
    this.selectedCategory,
    bool isLoading = false,
    String? error,
  }) : super(isLoading: isLoading, error: error);

  @override
  ProductsState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProductsState(
      products: products,
      featuredProducts: featuredProducts,
      mostWantedProducts: mostWantedProducts,
      categories: categories,
      selectedProduct: selectedProduct,
      selectedCategory: selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  ProductsState copyWith({
    List<Product>? products,
    List<Product>? featuredProducts,
    List<Product>? mostWantedProducts,
    List<app_category.Category>? categories,
    Product? selectedProduct,
    app_category.Category? selectedCategory,
    bool? isLoading,
    String? error,
    bool clearSelectedProduct = false,
    bool clearSelectedCategory = false,
    bool clearError = false,
  }) {
    return ProductsState(
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      mostWantedProducts: mostWantedProducts ?? this.mostWantedProducts,
      categories: categories ?? this.categories,
      selectedProduct: clearSelectedProduct ? null : selectedProduct ?? this.selectedProduct,
      selectedCategory: clearSelectedCategory ? null : selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  factory ProductsState.initial() {
    return const ProductsState(
      products: [],
      featuredProducts: [],
      mostWantedProducts: [],
      categories: [],
      selectedProduct: null,
      selectedCategory: null,
      isLoading: false,
      error: null,
    );
  }
}
