
import 'package:bid/models/products_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Shop extends ChangeNotifier {
final List<Product> _shop = [
  Product(name: "BIDHoodie", price: 99.99, description: "Item Description", imagePath: 'assets/images/BIDHoodie.jpg'),
  Product(name: "BIDTshirt", price: 99.99, description: "Item Description", imagePath: 'assets/images/BIDTshirt.jpg'),
  Product(name: "BIDSweater", price: 99.99, description: "Description", imagePath:'assets/images/BIDSweater.jpg'),
  Product(name: "BIDHoodie2", price: 99.99, description: "Description", imagePath: 'assets/images/BIDHoodie2.jpg'),
  Product(name: "BIDHoodie3", price: 99.99, description: "Item Description", imagePath: 'assets/images/BIDHoodie3.jpg'),
  Product(name: "BIDHoodie4", price: 99.99, description: "Item Description", imagePath: 'assets/images/BIDHoodie4.jpg'),
];

final List<String> imagePaths = [
  'assets/images/BIDHoodie2.jpg',
  'assets/images/BIDHoodie3.jpg',
  'assets/images/BIDHoodie4.jpg',
  'assets/images/BIDSweater2.jpg',
  'assets/images/BIDHoodie4.jpg'
];


final List<Product> _cart = [];
final List<Product> _wishlist = [];

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

