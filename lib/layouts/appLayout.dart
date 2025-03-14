
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../routes/route.dart';

@RoutePage()
class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        WelcomeRoute(),
        ProfileRoute(),
        CategoriesRoute(),
        WishlistRoute(),
        CartRoute(),
      ],

      appBarBuilder: (_, tabsRouter) {
        return AppBar(
          title: Text(
            _getAppBarTitle(tabsRouter.activeIndex),
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 14),
          ),
          automaticallyImplyLeading: tabsRouter.activeIndex != 0,
          leading: tabsRouter.canPop()
              ? IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              tabsRouter.back();
            },
          )
              : null,
        );
      },
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            tabsRouter.setActiveIndex(index);
          },
          type: BottomNavigationBarType.fixed,
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
    );
  }
}

String _getAppBarTitle(int tabIndex) {
  switch (tabIndex) {
    case 0:
      return "Home";
    case 1:
      return "Profile";
    case 2:
      return "Shop";
    case 3:
      return "Wishlist";
    case 4:
      return "Cart";
    default:
      return "Home";
  }
}
