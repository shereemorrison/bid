/*import 'package:auto_route/auto_route.dart';
import 'package:bid/components/my_list_tile.dart';
import 'package:flutter/material.dart';

import '../routes/route.dart';

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
            child: Container(
              child: Center(
                child: Image.asset('assets/images/bidoverlay.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),

          /*Padding(padding: const EdgeInsets.all(8.0),
          child: Text("B E L I E V E  I N  D R E A M S"),
          ),*/

          const SizedBox(height: 10),

          //shop tile
          MyListTile(
              text: "Men",
              icon: Icons.man,
              onTap: () {
                Navigator.pop(context);
                context.router.push(ShopMenRoute());
              }
          ),

          //cart
          MyListTile(
            text: "Women",
            icon: Icons.woman,
            onTap: () {
              Navigator.pop(context);
              context.pushRoute(ShopMenRoute());
            },
          ),

          //login
          MyListTile(
            text: "Unisex",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              context.pushRoute(ShopMenRoute());
            },
          ),

          MyListTile(
            text: "Accessories",
            icon: Icons.shopping_bag,
            onTap: () {
              Navigator.pop(context);
              context.pushRoute(ShopMenRoute());
            },
          ),

          MyListTile(
            text: "Cart",
            icon: Icons.shopping_cart,
            onTap: () {
              Navigator.pop(context);
              context.pushRoute(CartRoute());
            },
          )
        ],
      ),
    );
  }
}
*/