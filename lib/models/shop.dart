import 'package:bid/models/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Shop extends ChangeNotifier {
final List<Product> _shop = [
  Product(name: "BID OG", price: 99.99, description: "Item Description..", imagePath: 'assets/images/greyhoodie.jpg'),
  // other products
];

List<Product> _cart = [];
List<Product> _wishlist = [];

List<Product> get shop => _shop;
List<Product> get cart => _cart;
List<Product> get wishlist => _wishlist;

double get totalAmount {
  return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

// Directly modifying lists
void addToCart(Product product) {
  _cart.add(product);
  notifyListeners();
}

void removeFromCart(Product product) {
  _cart.remove(product);
  notifyListeners();
}

void addToWishlist(Product product) {
  _wishlist.add(product);
  notifyListeners();
}

void removeFromWishlist(Product product) {
  _wishlist.remove(product);
  notifyListeners();
}
}

