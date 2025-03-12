/*import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '../routes/route.dart';


class MyNavbar extends StatelessWidget {
  final int selectedIndex;

  const MyNavbar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: selectedIndex,
      onTap: (int index) {
        switch (index)
            {
          case 0:
            context.pushRoute(IntroRoute());
            break;
          case 1:
            context.pushRoute(ProfileRoute());
            break;
          case 2:
            context.pushRoute(ShopRoute());
            break;
          case 3:
            context.pushRoute(WishlistRoute());
            break;
          case 4:
            context.pushRoute(CartRoute());
        }
      },
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      selectedItemColor: Theme.of(context).colorScheme.surface,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
      ],
    );
  }
}*/
