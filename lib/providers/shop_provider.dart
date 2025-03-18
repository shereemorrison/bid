import 'package:flutter/material.dart';
import '../models/products_model.dart';

class Shop extends ChangeNotifier {
  final List<Product> _shop = [];
  final List<Product> _cart = [];
  final List<Product> _wishlist = [];

  List<Product> get shop => _shop;
  List<Product> get cart => _cart;
  List<Product> get wishlist => _wishlist;

  // Update shop list with products from Supabase
  void updateProducts(List<Product> products) {
    _shop.clear();
    _shop.addAll(products);
    notifyListeners();
  }

  double get totalAmount {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addToCart(Product product) {
    // Check if product already exists in cart
    final existingIndex = _cart.indexWhere((item) => item.id == product.id);

    if (existingIndex >= 0) {
      // If product exists, increase quantity
      final existingProduct = _cart[existingIndex];
      _cart[existingIndex] = existingProduct.copyWith(
          quantity: existingProduct.quantity + 1
      );
    } else {
      // Otherwise add new product
      _cart.add(product);
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void addToWishlist(Product product) {
    if (!_wishlist.any((item) => item.id == product.id)) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    _wishlist.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }
}

