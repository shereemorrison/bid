
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bid/components/cards/small_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cards/shop_product_card.dart';
import '../components/widgets/featured_carousel.dart';
import '../components/widgets/product_grid_item.dart';
import '../components/widgets/search_bar.dart';
import '../providers/shop_provider.dart';

@RoutePage()
class ShopMenPage extends StatefulWidget {
  const ShopMenPage({super.key});

  @override
  _ShopMenPageState createState() => _ShopMenPageState();
}

class _ShopMenPageState extends State<ShopMenPage> {


  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<Shop>(context);

    /* TODO - Implement filter products for men's category once database implemented.
    TODO - Remember to update products.length/index etc to menproducts

    final menProducts = shop.productShop.where((product) =>
    product.category == 'men' || product.category == 'mens').toList(); */

    final products = context.watch<Shop>().shop;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Text(
                "Shop Men",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              const CustomSearchBar(),

              /* Featured Products Section
              Text(
                "Featured",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 12),

              // Featured Carousel
              FeaturedCarousel(products: featuredProduct),*/
              const SizedBox(height: 24),

              // All Products Section
              Text(
                "All Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 12),

              // Grid of Products
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductGridItem(product: products[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
