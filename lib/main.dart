import 'package:bid/models/shop.dart';
import 'package:bid/pages/cart_page.dart';
import 'package:bid/pages/intro_page.dart';
import 'package:bid/pages/login_page.dart';
import 'package:bid/pages/profile_page.dart';
import 'package:bid/pages/register_page.dart';
import 'package:bid/pages/shop_page.dart';
import 'package:bid/pages/signup_page.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:bid/components/my_button.dart'
    '';
import 'package:provider/provider.dart';

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/shop_page': (context) => const ShopPage(),
        '/login_page': (context) => LoginPage(onTap: () {},),
        '/cart_page' : (context) => const CartPage(),
        '/profile_page' : (context) => const ProfilePage(),
        '/signup_page' : (context) => const SignupPage(),
        '/register_page' : (context) => RegisterPage(onTap: () {  },)
      },

    );
  }
}

