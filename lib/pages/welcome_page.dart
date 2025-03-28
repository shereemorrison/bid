import 'package:bid/services/category_service.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/widgets/welcome_header.dart';
import 'package:bid/components/widgets/search_bar.dart';
import 'package:bid/components/widgets/product_horizontal_list.dart';
import 'package:bid/services/welcome_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/widgets/category_chips.dart';
import '../components/widgets/featured_grid.dart';
import '../components/widgets/our_story_section.dart';
import '../components/widgets/hero_section.dart';
import '../components/widgets/newsletter_section.dart';
import '../models/category_model.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final WelcomeService _welcomeService = WelcomeService();
  final TextEditingController _emailController = TextEditingController();
  final CategoryService _categoryService = CategoryService();

  List<Category> _categories = [];
  List<Category> _allCategories = [];
  List<String> _categoryNames = [];
  bool _isLoading = true;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when page initializes
  }

  @override
  void dispose() {
    _emailController.dispose();
    _welcomeService.dispose(); // Make sure to dispose the service
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
      await _welcomeService.loadAllData();
      _categories = await _categoryService.getCategories();

      final allCategory = Category(
          id: 'all',
          name: 'ALL',
          slug: 'all',
      );

      _allCategories = [allCategory, ..._categories];
      _categoryNames = _getCategories();

      // Make sure featured products are loaded
      if (_welcomeService.featuredProducts.isEmpty) {
        print('WelcomePage: No featured products found');
      }
    } catch (e) {
      print('WelcomePage: Error loading data: $e');
    } finally {
      // Update UI after loading completes
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredProducts = _welcomeService.featuredProducts;

    if (_selectedCategoryIndex > 0 && _selectedCategoryIndex < _allCategories.length) {
      final selectedCategory = _allCategories[_selectedCategoryIndex];
      if (selectedCategory.id != 'all') {
        filteredProducts = _welcomeService.featuredProducts
            .where((product) => product.categoryId == selectedCategory.id)
            .toList();
      }
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
                imageUrl: _welcomeService.getHeroImageUrl(),
                userName: _welcomeService.userName,
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
                  categories: _categoryNames,
                    selectedIndex: _selectedCategoryIndex,
                    onCategorySelected: (index) {
                    setState(() {
                      _selectedCategoryIndex = index;
          });
        },
      ),

                    const SizedBox(height: 20),

                    // Product Grid using featured products
                    if (_welcomeService.featuredProducts.isNotEmpty)
                      ProductGrid(
                        products: _welcomeService.featuredProducts,
                        getImageUrl: _welcomeService.getImageUrl,
                        onProductTap: (product) {
                          // Handle product tap
                          print('Tapped on ${product.name}');
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
                    if (_welcomeService.mostWantedProducts.isNotEmpty)
                      ProductHorizontalList(
                        products: _welcomeService.mostWantedProducts,
                        getImageUrl: _welcomeService.getImageUrl,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Featured Story Section with wraps image
              FeaturedStorySection(
                imageUrl: _welcomeService.getFeaturedStoryImageUrl(),
                onReadMorePressed: () {
                  // Handle read more button press
                },
              ),

              const SizedBox(height: 30),

              // Newsletter Section
              NewsletterSection(
                emailController: _emailController,
                onSubscribePressed: () {
                  // Handle subscribe button press
                  final email = _emailController.text;
                  if (email.isNotEmpty) {
                    // Process subscription
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Subscribed with email: $email')),
                    );
                    _emailController.clear();
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

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
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
  }
}

