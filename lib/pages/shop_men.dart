import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bid/components/my_product_tile.dart';
import 'package:bid/modals/shop.dart';
import 'package:bid/routes/route.gr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ShopMenPage extends StatefulWidget {
  const ShopMenPage({super.key});

  @override
  _ShopMenPageState createState() => _ShopMenPageState();
}

class _ShopMenPageState extends State<ShopMenPage> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
     context.pushRoute(IntroRoute());
    } else if (index == 1) {
      context.pushRoute(CartRoute());
    } else if (index == 2) {
      context.pushRoute(WishlistRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;
    return ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              "SHOP MEN",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemBuilder: (context, index) {
                final product = products[index];
                return MyProductTile(product: product);
              },
            ),
          ),
        ],
    );
  }
}
