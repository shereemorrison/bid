import 'package:bid/components/my_drawer.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:bid/components/my_product_tile.dart';
import 'package:bid/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {

    final products = context.watch<Shop>().shop;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Shop")
        ),
        //drawer: const MyDrawer(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ListView(
            children: [
              const SizedBox(height: 25),

              Center(
                child:  Text(
                  "Premium Quality Apparel",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),

              SizedBox(
                height: 370,
                child: ListView.builder(
                    itemCount: products.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return MyProductTile(product: product);
                    }
                ),
              ),
            ]
        )
    );
  }
}
