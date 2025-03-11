import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bid/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //drawer header
          Opacity(
            opacity: 0.5,
            child: Center(
              child: Image.asset('assets/images/bidoverlay.png',
                width: 150,
                height: 150,
              ),
            ),
          ),

          const SizedBox(height: 10),

          //shop tile
          MyListTile(
              text: "Men",
              icon: Icons.man,
              onTap: () {
                Navigator.pop(context);
                context.go('/shop_men');
              }
          ),

          //cart
          MyListTile(
            text: "Women",
            icon: Icons.woman,
            onTap: () {
              Navigator.pop(context);
              context.go('/shop_women');
            },
          ),

          MyListTile(
            text: "Accessories",
            icon: Icons.shopping_bag,
            onTap: () {
              Navigator.pop(context);
              context.go('/shop_accessories');
            },
          ),

          MyListTile(
            text: "Cart",
            icon: Icons.shopping_cart,
            onTap: () {
              Navigator.pop(context);
              context.go('/cart_page');
            },
          )
        ],
      ),
    );
  }
}