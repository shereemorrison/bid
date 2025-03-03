import 'package:bid/components/my_appbar.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:bid/components/my_product_tile.dart';
import 'package:bid/modals/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopMenPage extends StatefulWidget {
  const ShopMenPage({super.key});

  @override
  _ShopMenPageState createState() => _ShopMenPageState();
}

class _ShopMenPageState extends State<ShopMenPage> {
  // Track the selected index of the bottom navigation bar
  int selectedIndex = 0;

  // Function to handle item taps on the bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Add your navigation logic here based on selectedIndex
    if (index == 0) {
      // Example: Navigate to Home page
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      // Example: Navigate to Cart page
      Navigator.pushNamed(context, '/cart');
    } else if (index == 2) {
      // Example: Navigate to Wishlist page
      Navigator.pushNamed(context, '/wishlist');
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;
    return ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              "SHOP MEN",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemBuilder: (context, index) {
                final product = products[index];
                return MyProductTile(product: product);
              },
            ),
          ),
        ],
    );
  }
}
