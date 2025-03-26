// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'route.dart';

abstract class _$AppRouter extends RootStackRouter {
  _$AppRouter();

  @override
  final Map<String, PageFactory> pagesMap = {
    AccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountPage(),
      );
    },
    CartRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartPage(),
      );
    },
    CartRootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartRootPage(),
      );
    },
    CategoriesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CategoriesPage(),
      );
    },
    CategoriesRootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CategoriesRootPage(),
      );
    },
    IntroRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IntroPage(),
      );
    },
    MainLayoutRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainLayoutPage(),
      );
    },
    OrderSummaryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrderSummaryPage(),
      );
    },
    ProductDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ProductDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProductDetailPage(
          key: args.key,
          product: args.product,
        ),
      );
    },
    ShopAccessoriesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShopAccessoriesPage(),
      );
    },
    ShopMenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShopMenPage(),
      );
    },
    ShopRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShopPage(),
      );
    },
    ShopRootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShopRootPage(),
      );
    },
    ShopWomenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShopWomenPage(),
      );
    },
    WelcomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WelcomePage(),
      );
    },
    WishlistRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WishlistPage(),
      );
    },
  };
}

/// generated route for
/// [AccountPage]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CartPage]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CartRootPage]
class CartRootRoute extends PageRouteInfo<void> {
  const CartRootRoute({List<PageRouteInfo>? children})
      : super(
          CartRootRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CategoriesPage]
class CategoriesRoute extends PageRouteInfo<void> {
  const CategoriesRoute({List<PageRouteInfo>? children})
      : super(
          CategoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategoriesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CategoriesRootPage]
class CategoriesRootRoute extends PageRouteInfo<void> {
  const CategoriesRootRoute({List<PageRouteInfo>? children})
      : super(
          CategoriesRootRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategoriesRootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IntroPage]
class IntroRoute extends PageRouteInfo<void> {
  const IntroRoute({List<PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainLayoutPage]
class MainLayoutRoute extends PageRouteInfo<void> {
  const MainLayoutRoute({List<PageRouteInfo>? children})
      : super(
          MainLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainLayoutRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrderSummaryPage]
class OrderSummaryRoute extends PageRouteInfo<void> {
  const OrderSummaryRoute({List<PageRouteInfo>? children})
      : super(
          OrderSummaryRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderSummaryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProductDetailPage]
class ProductDetailRoute extends PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    Key? key,
    required Product product,
    List<PageRouteInfo>? children,
  }) : super(
          ProductDetailRoute.name,
          args: ProductDetailRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailRoute';

  static const PageInfo<ProductDetailRouteArgs> page =
      PageInfo<ProductDetailRouteArgs>(name);
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    required this.product,
  });

  final Key? key;

  final Product product;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [ShopAccessoriesPage]
class ShopAccessoriesRoute extends PageRouteInfo<void> {
  const ShopAccessoriesRoute({List<PageRouteInfo>? children})
      : super(
          ShopAccessoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShopAccessoriesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShopMenPage]
class ShopMenRoute extends PageRouteInfo<void> {
  const ShopMenRoute({List<PageRouteInfo>? children})
      : super(
          ShopMenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShopMenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShopPage]
class ShopRoute extends PageRouteInfo<void> {
  const ShopRoute({List<PageRouteInfo>? children})
      : super(
          ShopRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShopRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShopRootPage]
class ShopRootRoute extends PageRouteInfo<void> {
  const ShopRootRoute({List<PageRouteInfo>? children})
      : super(
          ShopRootRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShopRootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShopWomenPage]
class ShopWomenRoute extends PageRouteInfo<void> {
  const ShopWomenRoute({List<PageRouteInfo>? children})
      : super(
          ShopWomenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShopWomenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WelcomePage]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WishlistPage]
class WishlistRoute extends PageRouteInfo<void> {
  const WishlistRoute({List<PageRouteInfo>? children})
      : super(
          WishlistRoute.name,
          initialChildren: children,
        );

  static const String name = 'WishlistRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
