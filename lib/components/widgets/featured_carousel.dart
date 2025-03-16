import 'package:flutter/material.dart';
import '../../models/products_model.dart';

class FeaturedCarousel extends StatelessWidget {
  final List<String> imagePaths;
  final List<Product> products;
  final Function(int) onPageChanged;
  final int currentPage;
  final Color customBeige;

  const FeaturedCarousel({
    super.key,
    required this.imagePaths,
    required this.onPageChanged,
    required this.currentPage,
    required this.customBeige,
    this.products = const [], // Make products optional with default empty list
  });

  @override
  Widget build(BuildContext context) {
    final greyShade300 = Colors.grey.shade300;

    // Determine if we're using products or image paths
    final bool useProducts = products.isNotEmpty;
    final int itemCount = useProducts ? products.length : imagePaths.length;

    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: itemCount,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return useProducts
                  ? _buildProductCarouselItem(products[index], index, customBeige, greyShade300)
                  : _buildImageCarouselItem(imagePaths[index], index, customBeige, greyShade300);
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
                      : greyShade300.withOpacity(0.3),
                ),
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarouselItem(String imagePath, int index, Color customBeige, Color greyShade300) {
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
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
                    Colors.black.withOpacity(0.8),
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
                    index == 0 ? 'Fall Winter \'25':
                    index == 1 ? 'Holiday Collection' : 'Essentials',
                    style: TextStyle(
                      color: customBeige,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    index == 0 ? 'Winter Essentials' :
                    index == 1 ? 'Planning to get away?' : 'Must-haves',
                    style: TextStyle(
                      color: greyShade300,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCarouselItem(Product product, int index, Color customBeige, Color greyShade300) {
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(product.imagePath),
          fit: BoxFit.cover,
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
                    Colors.black.withOpacity(0.8),
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
                    product.name,
                    style: TextStyle(
                      color: customBeige,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: greyShade300,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Container(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
