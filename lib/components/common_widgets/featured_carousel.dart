import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bid/models/product_model.dart';

class FeaturedCarousel extends StatefulWidget {
  final String Function(int) getCollectionImageUrl;
  final Function(int) onPageChanged;
  final int currentPage;
  final String Function(String) getImageUrl;
  final List<String> collections;
  final List<String> collectionSlugs;
  final List<Product> products;

  const FeaturedCarousel({
    super.key,
    required this.getCollectionImageUrl,
    required this.onPageChanged,
    required this.currentPage,
    required this.getImageUrl,
    this.collections = const ['Winter', 'Holiday', 'Essentials'],
    this.collectionSlugs = const [],
    this.products = const [],
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: widget.currentPage,
    );
  }

  @override
  void didUpdateWidget(FeaturedCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage &&
        _pageController.hasClients &&
        _pageController.page?.round() != widget.currentPage) {
      _pageController.animateToPage(
        widget.currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.collections.length;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: _pageController,
            itemCount: itemCount,
            onPageChanged: widget.onPageChanged,
            itemBuilder: (context, index) {
              final product =
                  index < widget.products.length ? widget.products[index] : null;
              return _buildCarouselItem(context, index, product);
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            itemCount,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.currentPage == index
                    ? colorScheme.accent
                    : colorScheme.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, int index, Product? product) {
    final collectionName = index < widget.collections.length
        ? widget.collections[index]
        : 'Collection ${index + 1}';
    final slug = index < widget.collectionSlugs.length &&
            widget.collectionSlugs[index].isNotEmpty
        ? widget.collectionSlugs[index]
        : null;

    final collectionImage = widget.getCollectionImageUrl(index);
    final String imageUrl = collectionImage.isNotEmpty
        ? collectionImage
        : product != null
            ? widget.getImageUrl(product.imageUrl)
            : '';

    const titleColor = Colors.white;
    const descriptionColor = Color(0xDDFFFFFF);
    const buttonBorderColor = Colors.white;

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Theme.of(context).colorScheme.cardBackground,
        image: imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          if (imageUrl.isEmpty)
            Center(
              child: Icon(
                Icons.image_not_supported,
                size: 48,
                color: Theme.of(context).colorScheme.textSecondary,
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collectionName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Shop the latest collection',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: descriptionColor,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      if (slug != null) {
                        context.push('/shop/$slug');
                      } else {
                        context.push('/shop');
                      }
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
                              color: titleColor,
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
