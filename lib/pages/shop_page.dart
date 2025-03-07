import 'package:auto_route/annotations.dart';
import 'package:bid/components/my_product_tile.dart';
import 'package:bid/modals/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                  "F E A T U R E D",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
            ),

            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return MyProductTile(product: products[index], isSmall: true);
                },
              )
            ),
          ]
        ),
      ),
    );
  }
}

