import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/modals/shop.dart';
import 'package:bid/auth/auth_provider.dart';
import 'package:bid/routes/app_router.dart'; // Import the routes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => Shop()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Bid App',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      routerConfig: appRouter, // Use the imported router
    );
  }
}
