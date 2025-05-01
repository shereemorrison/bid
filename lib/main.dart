
import 'package:bid/providers.dart';
import 'package:bid/routes/app_router.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bid/supabase/supabase_config.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  // Generate or retrieve a persistent guest user ID
  final guestUserId = await initializeGuestUserId();
  final prefs = await SharedPreferences.getInstance();

  // Clean up all checkout-related data
  final oldKeys = prefs.getKeys().where((key) =>
  key == 'cart' ||
      key == 'wishlist' ||
      key.startsWith('checkout_') ||
      key.startsWith('address_') ||
      key.startsWith('payment_') ||
      key.startsWith('guest_order_') ||
      (key.startsWith('cart_') && !key.contains(guestUserId)) ||
      (key.startsWith('wishlist_') && !key.contains(guestUserId))
  ).toList();

  for (final key in oldKeys) {
    await prefs.remove(key);
    print('Removed old data key: $key');
  }

  Stripe.publishableKey = 'pk_test_51RG63pBLQQ4dypXtam2LgVa0Z7eqbR2EKEekCIp8iy7X4iiuRP1lGfMMAfsdwqKrsqyUez6Nal6XVeccP9Feug0U00RY0YG5ZI';
  await Stripe.instance.applySettings();

  SupabaseConfig.navigatorKey = GlobalKey<NavigatorState>();

  final container = ProviderContainer(
    overrides: [
      guestUserIdProvider.overrideWith((ref) => guestUserId),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guestId = ref.read(guestUserIdProvider);
    print('App started with guest user ID: $guestId');

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
