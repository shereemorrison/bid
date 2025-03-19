
import 'package:auto_route/auto_route.dart';
import 'package:bid/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bid/components/cards/category_card.dart';


@RoutePage()
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.search, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search for',
                                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.favorite_outline, color: Theme.of(context).colorScheme.primary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).colorScheme.primary,),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // TODO - CHANGE TO SWITCH STATEMENT
            // Category Grid
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Categories
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CategoryCard(
                              title: 'M E N',
                              imageUrl: 'assets/images/tshirt3.jpg',
                              onTap: () {
                                context.pushRoute(const ShopMenRoute(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CategoryCard(
                              title: 'W O M E N',
                              imageUrl: 'assets/images/tshirt3.jpg',
                              onTap: () {
                                context.pushRoute(ShopMenRoute());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Banner
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CategoryCard(
                        title: 'A C C E S S O R I E S',
                        imageUrl: 'assets/images/hoodie1.jpg',
                        onTap: () {
                          context.pushRoute(ShopMenRoute());
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CategoryCard(
                        title: 'S A L E',
                        imageUrl: 'assets/images/hoodie1.jpg',
                        onTap: () {
                          context.pushRoute(ShopMenRoute());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class ShopRootPage extends StatelessWidget {
  const ShopRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}



