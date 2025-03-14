

import 'package:bid/routes/route.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/supabase/supabase_config.dart';
import 'providers/shop_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  final appRouter = AppRouter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => Shop()),
      ],
      child: MyApp(appRouter: appRouter),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Autoroute',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter().config(),
    );
  }
}
