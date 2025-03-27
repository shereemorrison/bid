

import 'package:bid/providers/order_provider.dart';
import 'package:bid/providers/theme_provider.dart';
import 'package:bid/providers/user_provider.dart';
import 'package:bid/routes/app_router.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/supabase/supabase_config.dart';
import 'providers/shop_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  SupabaseConfig.navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SupabaseAuthProvider()),
        ChangeNotifierProvider(create: (context) => Shop()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'B.I.D.',
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        routerConfig: goRouter,
      );
      },
    );
  }
}
