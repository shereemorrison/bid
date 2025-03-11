import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int tabIndex;

  const MyAppbar({super.key, required this.title, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    // Get title based on current tab index
    String title = 'Home';
    switch (tabIndex) {
      case 0:
        title = 'Home';
        break;
      case 1:
        title = 'Profile';
        break;
      case 2:
        title = 'Shop';
        break;
      case 3:
        title = 'Wishlist';
        break;
      case 4:
        title = 'Cart';
        break;
    }

    return AppBar(
      title: Text(
          (title),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.white)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        // Add your app bar actions here
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Handle search action
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}