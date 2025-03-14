/*import 'package:bid/modals/paymentmodal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bid/pages/appLayout.dart';
import 'package:bid/pages/intro_screen.dart';
import 'package:bid/pages/profile_page.dart';
import 'package:bid/pages/shop_page.dart';
import 'package:bid/pages/wishlist_page.dart';
import 'package:bid/pages/cart_page.dart';
import 'package:bid/pages/shop_men_screen.dart';
import 'package:bid/pages/shop_women_screen.dart';
import 'package:bid/pages/shop_accessories_screen.dart';

// Keep track of previous index
int _lastIndex = 0;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.toString();
        int newIndex = 0;

        if (location.startsWith('/profile_page')) {
          newIndex = 1;
        } else if (location.startsWith('/shop_page')) {
          newIndex = 2;
        } else if (location.startsWith('/wishlist_page')) {
          newIndex = 3;
        } else if (location.startsWith('/cart_page')) {
          newIndex = 4;
        }

        return MainLayout(currentIndex: newIndex, child: child);
      },
      routes: [
        GoRoute(path: '/', pageBuilder: (context, state) => _buildPage(state, const IntroPage(), 0)),
        GoRoute(path: '/profile_page', pageBuilder: (context, state) => _buildPage(state, const ProfilePage(), 1)),
        GoRoute(path: '/shop_page', pageBuilder: (context, state) => _buildPage(state, const ShopPage(), 2)),
        GoRoute(path: '/wishlist_page', pageBuilder: (context, state) => _buildPage(state, const WishlistPage(), 3)),
        GoRoute(path: '/cart_page', pageBuilder: (context, state) => _buildPage(state, const CartPage(), 4)),
        GoRoute(path: '/shop_men', builder: (context, state) => const ShopMenPage()),
        GoRoute(path: '/shop_women', builder: (context, state) => const ShopWomenPage()),
        GoRoute(path: '/shop_accessories', builder: (context, state) => const ShopAccessoriesPage()),
        GoRoute(
          path: '/paymentmodal',
          builder: (context, state) {
            final double totalAmount = state.extra as double;
            return PaymentScreen(totalAmount: totalAmount);
          },
        ),
      ],
    ),
  ],
);

Page _buildPage(GoRouterState state, Widget page, int newIndex) {
  bool isForward = newIndex > _lastIndex;

  const beginRight = Offset(1.0, 0.0);
  const beginLeft = Offset(-1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: isForward ? beginRight : beginLeft, end: end)
      .chain(CurveTween(curve: curve));

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _lastIndex = newIndex;
  });

  return CustomTransitionPage(
    key: state.pageKey,
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}*/
