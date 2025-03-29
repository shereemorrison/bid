import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/pages/home_page.dart';
import 'package:bid/pages/account_page.dart';
import 'package:bid/pages/cart_page.dart';
import 'package:bid/pages/categories_page.dart';
import 'package:bid/pages/wishlist_page.dart';
import 'package:bid/pages/shop_men_page.dart';
import 'package:bid/pages/shop_women_page.dart';
import 'package:bid/pages/shop_accessories_page.dart';
import 'package:bid/pages/product_detail_page.dart';

import '../layouts/appLayout.dart';
import '../pages/order_summary_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,

redirect: (BuildContext context, GoRouterState state) {
// Get the current location
  final location = state.uri.path;
  return null;
},
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        // Home Tab
        GoRoute(
          path: '/',
          name: 'Home',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),


        // Shop/Categories Tab with nested routes
        GoRoute(
          path: '/shop',
          name: 'shop',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const CategoriesPage(),
          ),
          routes: [
            GoRoute(
              path: 'men',
              name: 'shop_men',
              builder: (context, state) => const ShopMenPage(),
            ),
            GoRoute(
              path: 'women',
              name: 'shop_women',
              builder: (context, state) => const ShopWomenPage(),
            ),
            GoRoute(
              path: 'accessories',
              name: 'shop_accessories',
              builder: (context, state) => const ShopAccessoriesPage(),
            ),
            GoRoute(
              path: 'product',
              name: 'product_detail',
              builder: (context, state) {
                final product = state.extra as Product;
                return ProductDetailPage(product: product);
              },
            ),// Account Tab

          ],
        ),

        GoRoute(
          path: '/account',
          name: 'account',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const AccountPage(),
          ),
        ),
        // Wishlist Tab
        GoRoute(
          path: '/wishlist',
          name: 'wishlist',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const WishlistPage(),
          ),
        ),

        // Cart Tab with nested routes
        GoRoute(
          path: '/cart',
          name: 'cart',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const CartPage(),
          ),
          routes: [
            GoRoute(
              path: 'summary',
              name: 'order_summary',
              builder: (context, state) => const OrderSummaryPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);