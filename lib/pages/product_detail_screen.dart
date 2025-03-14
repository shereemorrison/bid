
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = '44';
  String selectedColor = 'Dusty Beige';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.search),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.bag),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Product Image
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/hoodie.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Brand and Product Name
                    Container(
                      color: const Color(0xFFb8b0a4),
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'B I D - Essentials',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Relaxed Hoodie',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product Description
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'The Eternal lapelless jacket is constructed from an Italian wool gabardine to maintain an ideal weight and drape for tailoring. The collarless, single-breasted design is boxy with dropped shoulders allowing a cardigan-like comfort.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    // Color Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedColor,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),

                    const Divider(height: 32),

                    // Size Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedSize,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Add to Cart Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Text(
                          'ADD TO CART',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
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