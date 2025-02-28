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
import 'package:bid/modals/loginpage.dart';
import 'package:bid/modals/registrationpage.dart';
import 'package:bid/components/my_navbar.dart';

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
          '/intro_page': (context) => const IntroPage(),
          '/shop_page': (context) => const ShopPage(),
          '/cart_page' : (context) => const CartPage(),
          '/profile_page' : (context) => const ProfilePage(),
          '/wishlist_page' : (context) => const WishlistPage(),
        },
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const IntroPage(),
    const ProfilePage(),
    const ShopPage(),
    const WishlistPage(),
    const CartPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle())),
      body: _pages[_selectedIndex],
      bottomNavigationBar: MyNavbar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }

  String _getAppBarTitle() {
    var currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == '/login') {
      return "Login";
    } else if (currentRoute == '/register') {
      return "Register";
    }

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
