import 'package:auto_route/auto_route.dart';
import 'package:bid/components/my_appbar.dart';
import 'package:bid/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/my_navbar.dart';

import '../routes/route.gr.dart';

@RoutePage()
class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        IntroRoute(),
        ProfileRoute(),
        ShopRoute(),
        WishlistRoute(),
        CartRoute(),
      ],
      appBarBuilder: (_, tabsRouter) {
        return MyAppbar(tabIndex: tabsRouter.activeIndex);
      },
      drawer: MyDrawer(), // Your custom Drawer
      bottomNavigationBuilder: (_, tabsRouter) {
        return MyNavbar(
          selectedIndex: tabsRouter.activeIndex,
        );
      },
    );
  }
}
