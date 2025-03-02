import 'package:bid/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //drawer header
          Opacity(
            opacity: 0.5,
            child: Container(
              child: Center(
                child: Image.asset('assets/images/Logo.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),

          Padding(padding: const EdgeInsets.all(8.0),
          child: Text("B E L I E V E  I N  D R E A M S"),
          ),

          const SizedBox(height: 10),

          //shop tile
          MyListTile(
              text: "Men",
              icon: Icons.man,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/shop_page');
              }
          ),

          //cart
          MyListTile(
            text: "Women",
            icon: Icons.woman,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shop_page');
            },
          ),

          //login
          MyListTile(
            text: "Unisex",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shop_page');
            },
          ),

          MyListTile(
            text: "Accessories",
            icon: Icons.shopping_bag,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shop_page');
            },
          ),

          MyListTile(
            text: "Cart",
            icon: Icons.shopping_cart,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart_page');
            },
          )
        ],
      ),
    );
  }
}
