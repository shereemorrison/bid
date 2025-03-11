import 'package:bid/modals/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Shop extends ChangeNotifier {
  // Products for sale
  final List<Product> _shop = [
    Product(
      name: "BID OG",
      price: 99.99,
      description: "Item Description..",
      imagePath: 'assets/images/greyhoodie.jpg',
    ),
    Product(
      name: "BID Elite",
      price: 99.99,
      description: "Item Description..",
      imagePath: 'assets/images/tshirt.jpg',
    ),
    Product(
      name: "BID Champion",
      price: 99.99,
      description: "Item Description..",
      imagePath: 'assets/images/tshirt.jpg',
    ),
    Product(
      name: "BID Contend",
      price: 99.99,
      description: "Item Description..",
      imagePath: 'assets/images/tshirt.jpg',
    ),
    Product(
      name: "BID Defence",
      price: 99.99,
      description: "Item Description..",
      imagePath: 'assets/images/tshirt.jpg',
    ),
    Product(
      name: "BID Offence",
      price: 99.99,
      description: "Item Description..",
      imagePath: 'assets/images/greyhoodie.jpg',
    ),
  ];

  // User cart and wishlist
  List<Product> _cart = [];
  List<Product> _wishlist = [];

  // Getters for the shop, cart, and wishlist
  List<Product> get shop => _shop;

  List<Product> get cart => _cart;

  List<Product> get wishlist => _wishlist;

  // Compute total amount for the cart
  double get totalAmount {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Add item to the cart
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners(); // Notify listeners after updating the cart
  }


  // Remove item from the cart
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners(); // Notify listeners after updating the cart
  }

  // Add item to the wishlist
  void addToWishlist(Product item) {
    _wishlist.add(item);
    notifyListeners(); // Notify listeners after updating the wishlist
  }

  // Remove item from the wishlist
  void removeFromWishlist(Product item) {
    _wishlist.remove(item);
    notifyListeners(); // Notify listeners after updating the wishlist
  }

}
