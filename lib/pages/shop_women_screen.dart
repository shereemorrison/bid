
import 'package:bid/components/cards/shop_product_card.dart';
import 'package:bid/archive/small_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';

class ShopWomenPage extends StatefulWidget {

  const ShopWomenPage({super.key});

  @override
  State<ShopWomenPage> createState() => _ShopWomenPageState();
}

class _ShopWomenPageState extends State<ShopWomenPage> {
  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),

              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ShopProductCard(product: product);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
