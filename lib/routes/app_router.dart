import 'package:bid/components/address_widgets/address_form.dart';
import 'package:bid/models/address_model.dart';
import 'package:bid/pages/checkout_page.dart';
import 'package:bid/pages/guest_order_details_page.dart';
import 'package:bid/pages/guest_orders_page.dart';
import 'package:bid/pages/login_page.dart';
import 'package:bid/pages/order_confirmation_page.dart';
import 'package:bid/pages/order_details_page.dart';
import 'package:bid/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bid/models/product_model.dart';
import 'package:bid/pages/home_page.dart';
import 'package:bid/pages/account/account_page.dart';
import 'package:bid/pages/cart_page.dart';
import 'package:bid/pages/categories_page.dart';
import 'package:bid/pages/wishlist_page.dart';
import 'package:bid/pages/shop_men_page.dart';
import 'package:bid/pages/shop_women_page.dart';
import 'package:bid/pages/shop_accessories_page.dart';
import 'package:bid/pages/product_detail_page.dart';
import '../layouts/appLayout.dart';

class RouterNotifier extends ChangeNotifier {
  bool _shouldRefresh = false;

  void refresh() {
    _shouldRefresh = true;
    notifyListeners();
  }

  bool get shouldRefresh => _shouldRefresh;

  void resetRefresh() {
    _shouldRefresh = false;
  }
}

final routerNotifier = RouterNotifier();

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _wishlistNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'wishlist');
final _shopNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shop');
final _cartNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'cart');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: false,

  routes: [
    GoRoute(
      path: '/order-confirmation',
      name: 'order_confirmation',
      pageBuilder: (context, state) {
        final orderId = state.uri.queryParameters['order_id'];
        return NoTransitionPage(
          key: state.pageKey,
          child: OrderConfirmationPage(orderId: orderId),
        );
      },
    ),

    GoRoute(
      path: '/address-form',
      name: 'address_form',
      pageBuilder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
        final Address? addressToEdit = extra['addressToEdit'] as Address?;
        final Function(Address)? onSave = extra['onSave'] as Function(Address)?;

        return NoTransitionPage(
          key: state.pageKey,
          child: AddressForm(
            addressToEdit: addressToEdit,
            onSave: onSave ?? ((_) {}),
          ),
        );
      },
    ),

    // Auth routes (outside of the bottom navigation)
    GoRoute(
      path: '/account/login',
      name: 'login',
      pageBuilder: (context, state) {
        final redirectPath = state.uri.queryParameters['redirect'];
        return NoTransitionPage(
          key: state.pageKey,
          child: LoginPage(redirectPath: redirectPath),
        );
      },
    ),

    GoRoute(
      path: '/account/register',
      name: 'register',
      pageBuilder: (context, state) {
        final redirectPath = state.uri.queryParameters['redirect'];
        final initialData = state.extra as Map<String, dynamic>?;
        return NoTransitionPage(
          key: state.pageKey,
          child: RegisterPage(
            redirectPath: redirectPath,
            initialData: initialData,
          ),
        );
      },
    ),

    // In app_router.dart
    GoRoute(
      path: '/guest-orders',
      name: 'guest_orders',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const GuestOrdersPage(),
      ),
    ),
    GoRoute(
      path: '/guest-orders/:orderId',
      name: 'guest_order_details',
      pageBuilder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return NoTransitionPage(
          key: state.pageKey,
          child: GuestOrderDetailsPage(orderId: orderId),
        );
      },
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppLayout(navigationShell: navigationShell);
      },
      branches: [
        // Home Tab
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              name: 'Home',
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const HomePage(),
                  ),
            ),
          ],
        ),

        // Wishlist Tab
        StatefulShellBranch(
          navigatorKey: _wishlistNavigatorKey,
          routes: [
            GoRoute(
              path: '/wishlist',
              name: 'wishlist',
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const WishlistPage(),
                  ),
            ),
          ],
        ),

        // Shop/Categories Tab with nested routes
        StatefulShellBranch(
          navigatorKey: _shopNavigatorKey,
          routes: [
            GoRoute(
              path: '/shop',
              name: 'shop',
              pageBuilder:
                  (context, state) => NoTransitionPage(
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
                ), // Account Tab
              ],
            ),
          ],
        ),

        // Cart Tab with nested routes
        StatefulShellBranch(
          navigatorKey: _cartNavigatorKey,
          routes: [
            GoRoute(
              path: '/cart',
              name: 'cart',
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const CartPage(),
                  ),
              routes: [
                GoRoute(
                  path: 'checkout', // Fixed: Removed leading slash
                  name: 'checkout',
                  builder: (context, state) => const CheckoutPage(),
                ),

              ],
            ),
          ],
        ),

        //Account tab
        StatefulShellBranch(
          navigatorKey: _accountNavigatorKey,
          routes: [
            GoRoute(
              path: '/account',
              name: 'account',
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const AccountPage(),
                  ),
              routes: [
                GoRoute(
                  path: 'order/:orderId',
                  name: 'order_details',
                  builder: (context, state) {
                    final orderId = state.pathParameters['orderId']!;
                    return OrderDetailsPage(orderId: orderId);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
