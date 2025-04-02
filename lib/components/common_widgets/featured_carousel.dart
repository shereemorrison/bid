import 'dart:math' as Math;

import 'package:bid/models/products_model.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class FeaturedCarousel extends StatelessWidget {
  final String Function(int) getCollectionImageUrl;
  final Function(int) onPageChanged;
  final int currentPage;
  final String Function(String) getImageUrl;
  final List<String> collections;
  final List<Product> products;

  FeaturedCarousel({
    super.key,
    required this.getCollectionImageUrl,
    required this.onPageChanged,
    required this.currentPage,
    required this.getImageUrl,
    this.collections = const ['Winter', 'Holiday', 'Essentials'],
    this.products = const [],
  });

  @override
  Widget build(BuildContext context) {
    final int itemCount = Math.min(products.length, collections.length);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: PageController(viewportFraction: 1),
            itemCount: itemCount,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return _buildProductCarouselItem(products[index], index, context);
            },
          ),
        ),

        // Carousel indicator dots
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) =>
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index
                      ? colorScheme.accent
                      : colorScheme.textSecondary,
                ),
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCarouselItem(Product product, int index,
      BuildContext context) {
    // Get the image URL

    final String collectionName = index < collections.length
        ? collections[index]
        : 'Collection ${index + 1}';

    // ignore: unnecessary_null_comparison
    final String collectionImage = getCollectionImageUrl != null
        ? getCollectionImageUrl(index)
        : '';

    final String imageUrl = collectionImage.isNotEmpty
        ? collectionImage
        : getImageUrl(product.imageUrl);

    final textTheme = Theme.of(context).textTheme;
    const Color titleColor = Colors.white;
    const Color descriptionColor = Color(0xDDFFFFFF);
    const Color buttonTextColor = Colors.white;
    const Color buttonBorderColor = Colors.white;

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            print('Error loading image: $exception');
          },
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collectionName,
                    style: textTheme.headlineSmall?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Shop the latest collection',
                    style: textTheme.bodyMedium?.copyWith(
                      color: descriptionColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      // Handle button tap
                      print('Shop Now button tapped for ${collectionName}');
                      // TODO - Add navigation
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: buttonBorderColor),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Text(
                        'SHOP NOW',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: buttonTextColor,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

