import 'package:bid/components/my_drawer.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Wishlist")
      ),
      //drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      );
  }
}
