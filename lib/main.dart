import 'package:bid/providers.dart';
import 'package:bid/routes/app_router.dart';
import 'package:bid/supabase/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  // Clean up old data keys (no persistent guest IDs)
  final prefs = await SharedPreferences.getInstance();
  final oldKeys =
      prefs
          .getKeys()
          .where(
            (key) =>
                key == 'cart' ||
                key == 'wishlist' ||
                key.startsWith('checkout_') ||
                key.startsWith('address_') ||
                key.startsWith('payment_') ||
                key.startsWith('guest_order_') ||
                key.startsWith('cart_') ||
                key.startsWith('wishlist_'),
          )
          .toList();

  for (final key in oldKeys) {
    await prefs.remove(key);
    print('Removed old data key: $key');
  }

  // Note: Let the auth system handle session management naturally
  // This prevents interfering with guest sessions and cart persistence

  Stripe.publishableKey =
      'pk_test_51RG63pBLQQ4dypXtam2LgVa0Z7eqbR2EKEekCIp8iy7X4iiuRP1lGfMMAfsdwqKrsqyUez6Nal6XVeccP9Feug0U00RY0YG5ZI';
  await Stripe.instance.applySettings();

  SupabaseConfig.navigatorKey = GlobalKey<NavigatorState>();

  final container = ProviderContainer();

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('App started');

    final theme = ref.watch(themeProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'B.I.D.',
      theme: theme,
      darkTheme: theme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: goRouter,
    );
  }
}
