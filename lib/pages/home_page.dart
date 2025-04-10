import 'package:bid/components/category_widgets/category_chips.dart';
import 'package:bid/components/common_widgets/featured_carousel.dart';
import 'package:bid/components/common_widgets/featured_grid.dart';
import 'package:bid/components/home_widgets/hero_section.dart';
import 'package:bid/components/home_widgets/newsletter_section.dart';
import 'package:bid/components/home_widgets/our_story_section.dart';
import 'package:bid/models/category_model.dart';
import 'package:bid/services/category_service.dart';
import 'package:bid/services/home_service.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/product_widgets/product_horizontal_list.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeService _homeService = HomeService();
  final TextEditingController _emailController = TextEditingController();
  final CategoryService _categoryService = CategoryService();

  List<Category> _categories = [];
  List<Category> _allCategories = [];
  List<String> _categoryNames = [];
  bool _isLoading = true;
  String? _selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when page initializes
  }

  @override
  void dispose() {
    _emailController.dispose();
    _homeService.dispose(); // Make sure to dispose the service
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  List<String> _getCategories() {
    // Convert Category objects to strings
    return _allCategories.map((category) => category.name).toList();
  }

  // Load data and wait for it to complete
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all data including featured products
      await _homeService.loadAllData();
      _categories = await _categoryService.getCategories();

      final allCategory = Category(
          id: 'all',
          name: 'ALL',
          slug: 'all',
      );

      _allCategories = [allCategory, ..._categories];
      _categoryNames = _getCategories();

      // Make sure featured products are loaded
      if (_homeService.featuredProducts.isEmpty) {
        print('HomePage: No featured products found');
      }
    } catch (e) {
      print('HomePage: Error loading data: $e');
    } finally {
      // Update UI after loading completes
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
    List<dynamic> filteredProducts = _homeService.featuredProducts;

    if (_selectedCategoryId != null && _selectedCategoryId != 'all') {
        filteredProducts = _homeService.featuredProducts
            .where((product) => product.categoryId == _selectedCategoryId)
            .toList();
      }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section with training image
              HeroSection(
                imageUrl: _homeService.getHeroImageUrl(),
                userName: _homeService.userName,
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
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category Chips

                  CategoryChips(
                  categories: _allCategories,
                    selectedCategoryId: _selectedCategoryId,
                    onCategorySelected: _handleCategorySelected,
          ),

                    const SizedBox(height: 20),

                    // Product Grid using featured products
                    if (_homeService.featuredProducts.isNotEmpty)
                      ProductGrid(
                        products: _homeService.featuredProducts,
                        getImageUrl: _homeService.getImageUrl,
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
              if (_homeService.featuredProducts.isNotEmpty)
                FeaturedCarousel(
                  products: _homeService.featuredProducts,
                  getImageUrl: _homeService.getImageUrl,
                  getCollectionImageUrl: _homeService.getCollectionImageUrl,
                  onPageChanged: (index) {
                    setState(() {
                      _homeService.currentPage = index;
                    });
                  },
                  currentPage: _homeService.currentPage,
                ),

              SizedBox(height: 40),

              // Most Wanted Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOST WANTED',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Product Horizontal List
                    if (_homeService.mostWantedProducts.isNotEmpty)
                      ProductHorizontalList(
                        products: _homeService.mostWantedProducts,
                        getImageUrl: _homeService.getImageUrl,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Our Story
              OurStorySection(
                imageUrl: _homeService.getOurStoryImageUrl(),
                onReadMorePressed: () {
                  // Handle read more button press
                },
              ),

              const SizedBox(height: 15),

              // Newsletter Section
              NewsletterSection(
                  onSubscriptionComplete: (success, message) {
                    if (success) {
                    } else {
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
}

