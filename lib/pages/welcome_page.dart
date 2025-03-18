import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/widgets/welcome_header.dart';
import 'package:bid/components/widgets/search_bar.dart';
import 'package:bid/components/widgets/featured_carousel.dart';
import 'package:bid/components/widgets/product_horizontal_list.dart';
import 'package:bid/services/welcome_service.dart';
import 'package:provider/provider.dart';

import '../providers/supabase_auth_provider.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final WelcomeService _welcomeService = WelcomeService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when page initializes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<SupabaseAuthProvider>(context);
  }

  // Load data and wait for it to complete
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user name
      await _welcomeService.loadAllData();
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
    final customBeige = const Color(0xFFb8b0a4);
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                WelcomeHeader(
                  greeting: _welcomeService.getGreeting(),
                  userName: _welcomeService.userName,
                ),

                const SizedBox(height: 20),

                const CustomSearchBar(),

                const SizedBox(height: 30),

                // Only show carousel if there are images
                if (_welcomeService.featuredProducts.isNotEmpty)
                  FeaturedCarousel(
                    products: _welcomeService.featuredProducts,
                    getImageUrl: _welcomeService.getImageUrl,
                    onPageChanged: (index) {
                      setState(() {
                      _welcomeService.currentPage = index;
                    });
                  },
                  currentPage: _welcomeService.currentPage,
                  customBeige: customBeige,
                ),

                const SizedBox(height: 30),

                Text(
                  'Most Wanted',
                  style: TextStyle(
                    color: isLightMode ? Colors.black : customBeige,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Only show product list if there are images
                if (_welcomeService.mostWantedProducts.isNotEmpty)
                  ProductHorizontalList(
                    products: _welcomeService.mostWantedProducts,
                    getImageUrl: _welcomeService.getImageUrl,
                    customBeige: customBeige,
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

