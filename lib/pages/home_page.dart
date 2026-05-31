import 'package:bid/components/category_widgets/category_chips.dart';
import 'package:bid/components/common_widgets/featured_carousel.dart';
import 'package:bid/components/home_widgets/hero_section.dart';
import 'package:bid/components/home_widgets/newsletter_section.dart';
import 'package:bid/components/home_widgets/our_story_section.dart';
import 'package:bid/components/product_widgets/product_horizontal_list.dart';
import 'package:bid/models/category_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).loadInitialData();
    });
  }

  void _handleCategorySelected(Category category) {
    if (category.id == 'all') {
      setState(() => _selectedCategoryId = category.id);
    } else {
      context.push('/shop/${category.slug}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final collectionPreview = ref.watch(collectionPreviewProductsProvider);
    final mostWantedProducts = ref.watch(mostWantedProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final currentPage = ref.watch(currentPageProvider);

    if (productsState.isLoading && collectionPreview.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final displayMostWanted = mostWantedProducts.isNotEmpty
        ? mostWantedProducts
        : collectionPreview.take(8).toList();

    final allCategory = Category(id: 'all', name: 'ALL', slug: 'all');
    final allCategories = [allCategory, ...categories];

    final displayCollectionProducts =
        _selectedCategoryId != null && _selectedCategoryId != 'all'
            ? collectionPreview
                .where((p) => p.categoryId == _selectedCategoryId)
                .toList()
            : collectionPreview;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroSection(
                imageUrl: getHeroImageUrl(),
                userName: '',
                onShopNowPressed: () {},
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    CategoryChips(
                      categories: allCategories,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: _handleCategorySelected,
                    ),
                    const SizedBox(height: 20),
                    if (displayCollectionProducts.isNotEmpty)
                      ProductHorizontalList(
                        products: displayCollectionProducts.take(4).toList(),
                        getImageUrl: getSupabaseImageUrl,
                      )
                    else
                      const Center(
                        child: Text(
                          'No products available',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FeaturedCarousel(
                getImageUrl: getSupabaseImageUrl,
                getCollectionImageUrl: getCollectionImageUrl,
                onPageChanged: (index) {
                  ref.read(currentPageProvider.notifier).state = index;
                },
                currentPage: currentPage,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    if (displayMostWanted.isNotEmpty)
                      ProductHorizontalList(
                        products: displayMostWanted,
                        getImageUrl: getSupabaseImageUrl,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              OurStorySection(
                imageUrl: getOurStoryImageUrl(),
                onReadMorePressed: () {},
              ),
              const SizedBox(height: 15),
              const NewsletterSection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
