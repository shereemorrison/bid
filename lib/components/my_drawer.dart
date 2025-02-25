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
        children: [
          //drawer header
          DrawerHeader(
            child: Center(
              child: Image.asset('assets/images/Logo.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
          const SizedBox(height: 25),

          //shop tile
          MyListTile(
              text: "Home",
              icon: Icons.home,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/intro_page');
              }
          ),

          //cart
          MyListTile(
            text: "Shop",
            icon: Icons.shopping_bag,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shop_page');
            },
          ),

          //login
          MyListTile(
            text: "Profile",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile_page');
            },
          ),

          MyListTile(
            text: "Wishlist",
            icon: Icons.checklist,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wishlist_page');
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
