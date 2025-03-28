import 'package:bid/themes/custom_colors.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import '../../models/products_model.dart';

class FeaturedCarousel extends StatelessWidget {
  final List<Product> products;
  final Function(int) onPageChanged;
  final int currentPage;
  final String Function(String) getImageUrl;
  final List<String> collections;

  const FeaturedCarousel({
    super.key,
    required this.onPageChanged,
    required this.currentPage,
    this.products = const [],
    required this.getImageUrl,
    this.collections = const ['Winter', 'Holiday', 'Essentials'],
  });

  @override
  Widget build(BuildContext context) {
    final int itemCount = products.length;

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
                      ? Theme.of(context).colorScheme.accent
                      : Theme.of(context).colorScheme.textSecondary,
                ),
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCarouselItem(Product product, int index, BuildContext context) {
    // Get the image URL
    final String imageUrl = getImageUrl(product.imageUrl);
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    // Get collection name based on index
    final String collectionName = index < collections.length
        ? collections[index]
        : 'Collection ${index + 1}';

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cardBackground,
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
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.background,
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collectionName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Shop the latest collection',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.textSecondary,
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
                        border: Border.all(color: Theme.of(context).colorScheme.accent),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Text(
                        'SHOP NOW',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.accent,
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

