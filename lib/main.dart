import 'package:bid/models/shop.dart';
import 'package:bid/pages/cart_page.dart';
import 'package:bid/pages/intro_page.dart';
import 'package:bid/pages/login_page.dart';
import 'package:bid/pages/profile_page.dart';
import 'package:bid/pages/registration_page.dart';
import 'package:bid/pages/shop_page.dart';
import 'package:bid/pages/signup_page.dart';
import 'package:bid/pages/wishlist_page.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:bid/components/my_button.dart';
import 'package:provider/provider.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:firebase_core/firebase_core.dart';

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
          '/login_page': (context) => LoginPage(onTap: () {}), // No navbar here
          '/cart_page' : (context) => const CartPage(),
          '/profile_page' : (context) => const ProfilePage(),
          '/signup_page' : (context) => const SignupPage(),
          '/registration_page' : (context) => RegistrationPage(onTap: () {}),
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Pages for navigation
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
      appBar: AppBar(
        title: const Text('BID'),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: MyNavbar(), // Global navbar component
    );
  }
}
