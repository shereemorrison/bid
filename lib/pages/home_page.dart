import 'package:bid/components/category_widgets/category_chips.dart';
import 'package:bid/components/common_widgets/featured_carousel.dart';
import 'package:bid/components/common_widgets/featured_grid.dart';
import 'package:bid/components/home_widgets/hero_section.dart';
import 'package:bid/components/home_widgets/newsletter_section.dart';
import 'package:bid/components/home_widgets/our_story_section.dart';
import 'package:bid/models/category_model.dart';
import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/product_widgets/product_horizontal_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final homeLoadingProvider = StateProvider<bool>((ref) => true);
final currentPageProvider = StateProvider<int>((ref) => 0);

// Provider for featured products
final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final productRepo = ref.read(productRepositoryProvider);
  return await productRepo.getFeaturedProducts();
});

// Provider for most wanted products
final mostWantedProductsProvider = FutureProvider<List<Product>>((ref) async {
  final productRepo = ref.read(productRepositoryProvider);
  return await productRepo.getMostWantedProducts();
});

// Provider for categories
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categoryRepo = ref.read(categoryRepositoryProvider);
  return await categoryRepo.getAllCategories();
});

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
      _loadInitialData();
    }); // Load data when page initializes
  }

  Future<void> _loadInitialData() async {
    ref
        .read(homeLoadingProvider.notifier)
        .state = true;

    // Loading of data through the providers
    await Future.wait([
      ref.read(featuredProductsProvider.future),
      ref.read(mostWantedProductsProvider.future),
      ref.read(categoriesProvider.future),
    ]);

    if (!mounted) return;
    ref
        .read(homeLoadingProvider.notifier)
        .state = false;
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
    final featuredProductsAsync = ref.watch(featuredProductsProvider);
    final mostWantedProductsAsync = ref.watch(mostWantedProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final isLoading = ref.watch(homeLoadingProvider);
    final currentPage = ref.watch(currentPageProvider);

    // Extract data from async values
    final featuredProducts = featuredProductsAsync.value ?? [];
    final mostWantedProducts = mostWantedProductsAsync.value ?? [];
    final categories = categoriesAsync.value ?? [];


    // Create allCategories list with "ALL" category
    final allCategory = Category(
      id: 'all',
      name: 'ALL',
      slug: 'all',
    );

    final List<Category> allCategories = [allCategory, ...categories];

    // Filter products based on selected category
    List<dynamic> filteredProducts = featuredProducts;
    if (_selectedCategoryId != null && _selectedCategoryId != 'all') {
      filteredProducts = featuredProducts
          .where((product) => product.categoryId == _selectedCategoryId)
          .toList();
    }


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
                imageUrl: getHeroImageUrl(),
                userName: "",
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
                        getImageUrl: getSupabaseImageUrl,
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
                  getImageUrl: getSupabaseImageUrl,
                  getCollectionImageUrl: getCollectionImageUrl,
                  onPageChanged: (index) {
                    ref
                        .read(currentPageProvider.notifier)
                        .state = index;
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
                        getImageUrl: getSupabaseImageUrl,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Our Story
              OurStorySection(
                imageUrl: getOurStoryImageUrl(),
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

