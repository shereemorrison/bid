import 'package:auto_route/auto_route.dart';
import 'package:bid/routes/route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: MainLayoutRoute.page,
      initial: true,
      children: [
        AutoRoute(page: IntroRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: CartRoute.page),
        AutoRoute(page: ShopRoute.page),
        AutoRoute(page: WishlistRoute.page)
      ],
    ),

  ];
}
