import 'package:bid/components/common_widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;

    if (location.startsWith('/wishlist')) {
      currentIndex = 1;
    } else if (location.startsWith('/shop')) {
      currentIndex = 2;
    } else if (location.startsWith('/cart')) {
      currentIndex = 3;
    }else if (location.startsWith('/account')) {
      currentIndex = 4;
      }

    final canGoBack = location != '/' &&
        location != '/shop' &&
        location != '/wishlist' &&
        location != '/cart' &&
        location != '/account';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          _getAppBarTitle(currentIndex, location),
          style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 14
          ),
        ),
        automaticallyImplyLeading: canGoBack,
        leading: canGoBack
            ? IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () => context.pop(),
        )
            : null,
        actions: const [
          ThemeToggle(),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/wishlist');
              break;
            case 2:
              context.go('/shop');
              break;
            case 3:
              context.go('/cart');
              break;
            case 4:
              context.go('/account');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
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