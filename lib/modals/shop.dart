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

  //user cart
  List<Product> _cart = [];

  //get product list
  List<Product> get shop => _shop;

  //get user cart
  List<Product> get cart => _cart;

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

}