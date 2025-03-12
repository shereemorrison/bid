import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final int tabIndex;

  const MyAppbar({super.key, required this.tabIndex});

  String _getAppBarTitle() {
    switch (tabIndex) {
      case 0:
        return "Intro";
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        _getAppBarTitle(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 15,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
