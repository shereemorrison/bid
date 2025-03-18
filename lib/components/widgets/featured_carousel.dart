import 'package:flutter/material.dart';
import '../../models/products_model.dart';

class FeaturedCarousel extends StatelessWidget {
  final List<Product> products;
  final Function(int) onPageChanged;
  final int currentPage;
  final Color customBeige;
  final String Function(String) getImageUrl;
  final List<String> collections;

  const FeaturedCarousel({
    super.key,
    required this.onPageChanged,
    required this.currentPage,
    required this.customBeige,
    this.products = const [],
    required this.getImageUrl,
    this.collections = const ['Winter', 'Holiday', 'Essentials'],
  });

  @override
  Widget build(BuildContext context) {
    final greyShade300 = Colors.grey.shade300;

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
              return _buildProductCarouselItem(products[index], index, customBeige, greyShade300, context);
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
                      ? customBeige
                      : greyShade300,
                ),
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCarouselItem(Product product, int index, Color customBeige, Color greyShade300, BuildContext context) {
    // Get the image URL
    final String imageUrl = getImageUrl(product.imageUrl);

    // Get collection name based on index
    final String collectionName = index < collections.length
        ? collections[index]
        : 'Collection ${index + 1}';

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(15),
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
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collectionName,
                    style: TextStyle(
                      color: customBeige,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Shop the latest collection',
                    style: TextStyle(
                      color: greyShade300,
                      fontSize: 14,
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
                        border: Border.all(color: customBeige),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'SHOP NOW',
                        style: TextStyle(
                          color: customBeige,
                          fontSize: 12,
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

