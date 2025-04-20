

import 'package:bid/providers/theme_provider.dart';
import 'package:bid/routes/app_router.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bid/supabase/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  SupabaseConfig.navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      final isDarkMode = ref.watch(isDarkModeProvider);

      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'B.I.D.',
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        routerConfig: goRouter,
      );
  }
}
