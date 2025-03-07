import 'package:auto_route/auto_route.dart';
import 'package:bid/components/my_appbar.dart';
import 'package:bid/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/my_navbar.dart';

import '../routes/route.gr.dart';

@RoutePage()
class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        IntroRoute(),
        ProfileRoute(),
        ShopRoute(),
        WishlistRoute(),
        CartRoute(),
      ],

      appBarBuilder: (_, tabsRouter) {
      return MyAppbar(tabIndex: tabsRouter.activeIndex);
    },
      drawer: MyDrawer(),
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            tabsRouter.setActiveIndex(index);  // Automatically handles navigation
          },
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          ],
        );
      },
      // Automatically provides the appropriate page content for each route
    );
  }
}




