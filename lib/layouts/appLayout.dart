import 'package:bid/components/common_widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppLayout({Key? key, required this.navigationShell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,
        elevation: 0,
        title: Text(
          _getAppBarTitle(navigationShell.currentIndex, GoRouterState
              .of(context)
              .uri
              .path),
          style: TextStyle(
              color: Theme
                  .of(context)
                  .colorScheme
                  .inversePrimary,
              fontSize: 14
          ),
        ),
        automaticallyImplyLeading: _canGoBack(context),
        leading: _canGoBack(context)
            ? IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary),
          onPressed: () => context.pop(),
        )
            : null,
        actions: const [
          ThemeToggle(),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme
            .of(context)
            .colorScheme
            .primary,
        selectedItemColor: Theme
            .of(context)
            .colorScheme
            .secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Shop'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  bool _canGoBack(BuildContext context) {
    final RouteMatch lastMatch = GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final String location = lastMatch.matchedLocation;

    return location != '/' &&
        location != '/wishlist' &&
        location != '/shop' &&
        location != '/cart' &&
        location != '/account';
  }

  String _getAppBarTitle(int tabIndex, String location) {
    if (location.contains('/shop/men')) {
      return "Men's Collection";
    } else if (location.contains('/shop/women')) {
      return "Women's Collection";
    } else if (location.contains('/shop/accessories')) {
      return "Accessories";
    } else if (location.contains('/shop/product')) {
      return "Product Details";
    } else if (location.contains('/cart/summary')) {
      return "Order Summary";
    }
    switch (tabIndex) {
      case 0: return "Home";
      case 1: return "Wishlist";
      case 2: return "Shop";
      case 3: return "Cart";
      case 4: return "Account";
      default: return "Home";
    }
  }
}