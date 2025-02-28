import 'package:bid/components/my_appbar.dart';
import 'package:bid/modals/shop.dart';
import 'package:bid/pages/cart_page.dart';
import 'package:bid/pages/intro_page.dart';
import 'package:bid/pages/profile_page.dart';
import 'package:bid/pages/shop_page.dart';
import 'package:bid/pages/wishlist_page.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bid/components/my_navbar.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.system,
        routes: {
          '/shop_page': (context) => MyHomePage(initialIndex: 2),
          '/profile_page': (context) => MyHomePage(initialIndex: 1),
          '/wishlist_page': (context) => MyHomePage(initialIndex: 3),
          '/cart_page': (context) => MyHomePage(initialIndex: 4),
        },
        navigatorKey: navigatorKey,
        home: const MyHomePage(initialIndex: 2),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int initialIndex;

  const MyHomePage({super.key, required this.initialIndex});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // Initialize the list inside initState
    _pages = [
      const IntroPage(),
      const ProfilePage(),
      const ShopPage(),
      const WishlistPage(),
      const CartPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: _getAppBarTitle()),
      body: _pages[_selectedIndex],
      bottomNavigationBar: MyNavbar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
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
}
