import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/widgets/welcome_header.dart';
import 'package:bid/components/widgets/category_dropdown.dart';
import 'package:bid/components/widgets/search_bar.dart';
import 'package:bid/components/widgets/featured_carousel.dart';
import 'package:bid/components/widgets/product_horizontal_list.dart';
import 'package:bid/services/welcome_service.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final WelcomeService _welcomeService = WelcomeService();
  bool _isDropdownOpen = false;
  final List<String> _categories = ['Men', 'Women', 'Accessories'];
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when page initializes
  }

  // Load data and wait for it to complete
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user name
      await _welcomeService.getUserName();

      print('WelcomePage: Images loaded. Main: ${_welcomeService.mainImagePaths.length}, Secondary: ${_welcomeService.imagePaths.length}');
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

    return Scaffold(
      backgroundColor: Colors.black,
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
                  isDropdownOpen: _isDropdownOpen,
                  onToggleDropdown: () {
                    setState(() {
                      _isDropdownOpen = !_isDropdownOpen;
                    });
                  },
                ),

                if (_isDropdownOpen)
                  CategoryDropdown(categories: _categories),

                const SizedBox(height: 20),

                const CustomSearchBar(),

                const SizedBox(height: 30),

                // Only show carousel if there are images
                _welcomeService.mainImagePaths.isNotEmpty
                    ? FeaturedCarousel(
                  imagePaths: _welcomeService.mainImagePaths,
                  onPageChanged: (index) {
                    setState(() {
                      _welcomeService.currentPage = index;
                    });
                  },
                  currentPage: _welcomeService.currentPage,
                  customBeige: customBeige, products: [],
                )
                    : Container(), // Empty container if no images

                const SizedBox(height: 30),

                Text(
                  'Most Wanted',
                  style: TextStyle(
                    color: customBeige,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Only show product list if there are images
                _welcomeService.imagePaths.isNotEmpty
                    ? ProductHorizontalList(
                  imagePaths: _welcomeService.imagePaths,
                  customBeige: customBeige,
                )
                    : Container(), // Empty container if no images

                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

