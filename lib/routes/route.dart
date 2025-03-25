import 'package:auto_route/auto_route.dart';
import 'package:bid/pages/welcome_page.dart';
import '../pages/account_page.dart';
import '../pages/cart_page.dart';
import '../pages/categories_page.dart';
import '../pages/intro_screen.dart';
import '../layouts/appLayout.dart';
import '../pages/order_summary_screen.dart';
import '../pages/shop_accessories_screen.dart';
import '../pages/shop_men_screen.dart';
import '../pages/shop_page.dart';
import '../pages/shop_women_screen.dart';
import '../pages/wishlist_page.dart';


part 'route.gr.dart';

class Paths {
  static const String root = '/';
  static const String intro = 'intro';
  static const String account = 'account';
  static const String cart = 'cart';
  static const String shop = 'shop';
  static const String shopMen = 'shop_men';
  static const String shopWomen = 'shop_women';
  static const String shopAccessories = 'shop_accessories';
  static const String wishlist = 'wishlist';
  static const String welcome = 'welcome_page';
  static const String ordersummary = 'summary_page';
  static const String categories = 'categories_screen';
}


@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: Paths.root,
      page: MainLayoutRoute.page,
      children: [
        AutoRoute(path: Paths.welcome, page: WelcomeRoute.page, initial: true),
        AutoRoute(path: Paths.account, page: AccountRoute.page),
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
          page: CategoriesRootRoute.page,
          children: [
            AutoRoute(path: "", page: CategoriesRoute.page),
            AutoRoute(path: Paths.shopMen, page: ShopMenRoute.page),
            AutoRoute(path: Paths.shopWomen, page: ShopWomenRoute.page),
            AutoRoute(path: Paths.shopAccessories, page: ShopAccessoriesRoute.page)
          ],
        ),
        AutoRoute(path: Paths.wishlist, page: WishlistRoute.page),
      ],
    ),
  ];
}