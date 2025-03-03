import 'package:bid/modals/products.dart';
import 'package:flutter/cupertino.dart';

class Shop extends ChangeNotifier {
  //products for sale
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

  //user cart and wishlist
  List<Product> _cart = [];
  List<Product> _wishlist = [];

  //getters
  List<Product> get shop => _shop;
  List<Product> get cart => _cart;
  List<Product> get wishlist => _wishlist;

  // Compute total amount
  double get totalAmount {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  //add item to cart
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  //remove item from cart
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
  // Add item to wishlist
  void addToWishlist(Product item) {
    _wishlist.add(item);
    notifyListeners();
  }

  // Remove item from wishlist
  void removeFromWishlist(Product item) {
    _wishlist.remove(item);
    notifyListeners();
  }
}

