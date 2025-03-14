import 'package:auto_route/auto_route.dart';
import 'package:bid/pages/welcome_page.dart';
import '../pages/cart_page.dart';
import '../pages/intro_page.dart';
import '../layouts/appLayout.dart';
import '../pages/order_summary_page.dart';
import '../pages/profile_page.dart';
import '../pages/shop_men.dart';
import '../pages/shop_page.dart';
import '../pages/wishlist_page.dart';
import '../pages/order_summary_page.dart';


part 'route.gr.dart';

class Paths {
  static const String root = '/';
  static const String intro = 'intro';
  static const String profile = 'profile';
  static const String cart = 'cart';
  static const String shop = 'shop';
  static const String shopMen = 'shop_men';
  static const String wishlist = 'wishlist';
  static const String welcome = 'welcome_page';
  static const String ordersummary = 'summary_page';
}


@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: Paths.root,
      page: MainLayoutRoute.page,
      children: [
        AutoRoute(path: Paths.welcome, page: WelcomeRoute.page),
        AutoRoute(path: Paths.profile, page: ProfileRoute.page),
        AutoRoute(
          path: Paths.cart,
          page: CartRootRoute.page,
          children: [
            AutoRoute(path: "", page: CartRoute.page),
            AutoRoute(path: Paths.ordersummary, page: OrderSummaryRoute.page),
          ],
        ),
        AutoRoute(
          path: Paths.shop,
          page: ShopRootRoute.page,
          children: [
            AutoRoute(path: "", page: ShopRoute.page),
            AutoRoute(path: Paths.shopMen, page: ShopMenRoute.page),
          ],
        ),
        AutoRoute(path: Paths.wishlist, page: WishlistRoute.page),
      ],
    ),
  ];
}