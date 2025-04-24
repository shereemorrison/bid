
import 'package:bid/routes/app_router.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bid/supabase/supabase_config.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  Stripe.publishableKey = 'pk_test_51RG63pBLQQ4dypXtam2LgVa0Z7eqbR2EKEekCIp8iy7X4iiuRP1lGfMMAfsdwqKrsqyUez6Nal6XVeccP9Feug0U00RY0YG5ZI';
  await Stripe.instance.applySettings();

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

      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'B.I.D.',
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.dark,
        routerConfig: goRouter,
      );
  }
}
