import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bid/components/category_card.dart';
import 'package:go_router/go_router.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _currentIndex = 1;

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
                          const Icon(CupertinoIcons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search for',
                                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
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
                    icon: const Icon(CupertinoIcons.bell),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.bag),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

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
                                context.go('/shop_men');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CategoryCard(
                              title: 'W O M E N',
                              imageUrl: 'assets/images/tshirt3.jpg',
                              onTap: () {
                                context.go('/shop_women');
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
                          context.go('/shop_accessories');
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