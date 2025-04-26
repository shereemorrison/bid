import 'package:bid/models/product_model.dart';
import 'package:flutter/foundation.dart';
import '../base/base_state.dart';

@immutable
class CartState extends BaseState {
  final List<CartItem> items;

  const CartState({
    this.items = const [],
    bool isLoading = false,
    String? error,
  }) : super(isLoading: isLoading, error: error);

  double get subtotal => items.fold(
      0, (sum, item) => sum + (item.price * item.quantity));

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  CartState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CartState(
      items: items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  factory CartState.initial() {
    return const CartState(
      items: [],
      isLoading: false,
      error: null,
    );
  }
}

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final Map<String, dynamic>? options;
  String? get selectedSize => options?['size'] as String?;

  final Product? _productRef;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.options,
    Product? productRef,
  }) : _productRef = productRef;

  // Getter that provides access to the product reference
  Product get product {
    // Return the stored reference if available
    if (_productRef != null) return _productRef!;

    // Otherwise create a minimal product from the stored data
    return Product(
      id: productId,
      name: name,
      price: price,
      description: '', // Default empty description
      categoryId: '', // Default empty categoryId
      isActive: true, // Default to active
      createdAt: DateTime.now(), // Default to current time
      imageUrl: imageUrl ?? '',
      quantity: quantity,
      selectedSize: options?['size'] as String?,
    );
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    Map<String, dynamic>? options,
    Product? productRef,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      options: options ?? this.options,
      productRef: productRef ?? _productRef,
    );
  }

  factory CartItem.fromProduct(Product product, {int quantity = 1, Map<String, dynamic>? options}) {
    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: quantity,
      imageUrl: product.imageUrl,
      options: options,
      productRef: product, // Store the reference to the original product
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'options': options,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
      options: json['options'],
    );
  }
}
