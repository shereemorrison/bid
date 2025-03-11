import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bid/components/my_appbar.dart';
import 'package:bid/components/my_drawer.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _lastIndex = 0;

  @override
  void didUpdateWidget(MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _lastIndex = oldWidget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    bool isForward = widget.currentIndex > _lastIndex;

    return Scaffold(
      appBar: MyAppbar(title: "B.I.D", tabIndex: widget.currentIndex),
      drawer: const MyDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          const beginRight = Offset(1.0, 0.0);
          const beginLeft = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: isForward ? beginRight : beginLeft,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: widget.currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/profile_page');
              break;
            case 2:
              context.go('/shop_page');
              break;
            case 3:
              context.go('/wishlist_page');
              break;
            case 4:
              context.go('/cart_page');
              break;
          }
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
      ),
    );
  }
}
