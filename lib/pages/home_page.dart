import 'package:bid/components/category_widgets/category_chips.dart';
import 'package:bid/components/common_widgets/featured_carousel.dart';
import 'package:bid/components/common_widgets/featured_grid.dart';
import 'package:bid/components/home_widgets/hero_section.dart';
import 'package:bid/components/home_widgets/newsletter_section.dart';
import 'package:bid/components/home_widgets/our_story_section.dart';
import 'package:bid/models/category_model.dart';
import 'package:bid/providers/category_provider.dart';
import 'package:bid/providers/home_provider.dart';
import 'package:bid/services/category_service.dart';
import 'package:bid/services/home_service.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/product_widgets/product_horizontal_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _emailController = TextEditingController();
  String? _selectedCategoryId = 'all';
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeNotifierProvider.notifier).loadAllData();
      ref.read(categoryNotifierProvider.notifier).loadCategories();
    }); // Load data when page initializes
  }

  @override
  void dispose() {
    _disposed = true;
    _emailController.dispose();
    super.dispose();
  }

  // Handle category selection - navigate to category page
  void _handleCategorySelected(Category category) {
    if (category.id == 'all') {
      setState(() {
        _selectedCategoryId = category.id;
      });
    } else {
      _navigateToCategory(category);
    }
  }

  void _navigateToCategory(Category category) {
    final path = '/shop/${category.slug}';
    final currentSelectedId = _selectedCategoryId;
    context.push(path);
  }

  @override
  Widget build(BuildContext context) {
    final featuredProducts = ref.watch(featuredProductsProvider);
    final mostWantedProducts = ref.watch(mostWantedProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final isLoading = ref.watch(homeLoadingProvider);
    final currentPage = ref.watch(currentPageProvider);
    final homeService = ref.read(homeServiceProvider);

    // Create allCategories list with "ALL" category
    final allCategory = Category(
      id: 'all',
      name: 'ALL',
      slug: 'all',
    );
    final allCategories = [allCategory, ...categories];

    // Filter products based on selected category
    List<dynamic> filteredProducts = featuredProducts;
    if (_selectedCategoryId != null && _selectedCategoryId != 'all') {
      filteredProducts = featuredProducts
          .where((product) => product.categoryId == _selectedCategoryId)
          .toList();
    }

    final homeNotifier = ref.read(homeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      body: SafeArea(
        child: isLoading
            ? const Center(
            child: CircularProgressIndicator()) // Show loading indicator
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section with training image
              HeroSection(
                imageUrl: homeNotifier.getHeroImageUrl(),
                userName: homeService.userName,
                onShopNowPressed: () {
                  // Handle shop now button press
                },
              ),

              const SizedBox(height: 30),

              // Categories and Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COLLECTIONS',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category Chips
                    CategoryChips(
                      categories: allCategories,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: _handleCategorySelected,
                    ),

                    const SizedBox(height: 20),

                    // Product Grid using featured products
                    if (featuredProducts.isNotEmpty)
                      ProductGrid(
                        products: filteredProducts,
                        getImageUrl: homeNotifier.getImageUrl,
                        onProductTap: (product) {
                          if (product != null) {
                            context.push('/shop/product', extra: product);
                          }
                        },
                      )
                    else
                      const Center(
                        child: Text(
                          'No featured products available',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //Featured Carousel
              if (featuredProducts.isNotEmpty)
                FeaturedCarousel(
                  products: featuredProducts,
                  getImageUrl: homeNotifier.getImageUrl,
                  getCollectionImageUrl: homeNotifier.getCollectionImageUrl,
                  onPageChanged: (index) {
                    ref.read(homeNotifierProvider.notifier).updateCurrentPage(
                        index);
                  },
                  currentPage: currentPage,
                ),

              const SizedBox(height: 40),

              // Most Wanted Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOST WANTED',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Product Horizontal List
                    if (mostWantedProducts.isNotEmpty)
                      ProductHorizontalList(
                        products: mostWantedProducts,
                        getImageUrl: homeNotifier.getImageUrl,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Our Story
              OurStorySection(
                imageUrl: homeNotifier.getOurStoryImageUrl(),
                onReadMorePressed: () {
                  // Handle read more button press
                },
              ),

              const SizedBox(height: 15),

              // Newsletter Section
              NewsletterSection(
                onSubscriptionComplete: (success, message) {
                  if (success) {} else {
                    print('Newsletter subscription failed: $message');
                  }
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

  /*Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }*/


