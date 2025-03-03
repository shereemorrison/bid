import 'package:flutter/material.dart';

class MyNavbar extends StatelessWidget {
  final ValueChanged<int> onItemTapped;
  final int selectedIndex;

  const MyNavbar({super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
      ],
    );
  }
}
