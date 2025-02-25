import 'package:bid/pages/intro_page.dart';
import 'package:bid/pages/profile_page.dart';
import 'package:bid/pages/shop_page.dart';
import 'package:bid/pages/wishlist_page.dart';
import 'package:flutter/material.dart';

class MyNavbar extends StatefulWidget {
  const MyNavbar({super.key});

  @override
  State<MyNavbar> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {

  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    print('Navigating to index $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of screens corresponding to the BottomNavigationBar items
  List<Widget> _pages = [
    IntroPage(),
    ProfilePage(),
    ShopPage(),
    WishlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed, // Static navigation bar

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
      ],
    ));
  }
}
