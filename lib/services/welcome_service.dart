
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/products_model.dart';
import '../supabase/supabase_config.dart';

class WelcomeService {
  String userName = '';
  int currentPage = 0;
  Timer? carouselTimer;

  final List<String> collections = ['Winter', 'Holiday', 'Essentials'];
  List<Product> featuredProducts = [];
  List<Product> mostWantedProducts = [];

  WelcomeService() {
    startCarouselTimer();
  }

  void startCarouselTimer() {
    carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
    });
  }

  void dispose() {
    carouselTimer?.cancel();
  }

  Future<void> getUserName() async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user != null) {
      // Try to get user metadata or profile info
      try {
        final userMetadata = user.userMetadata;
        if (userMetadata != null && userMetadata.containsKey('name')) {
          userName = userMetadata['name'] as String;
        } else {
          userName = user.email?.split('@').first ?? 'Guest';
        }
      } catch (e) {
        userName = user.email?.split('@').first ?? 'Guest';
      }
    } else {
      userName = 'Guest';
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      final response = await SupabaseConfig.client
          .from('products')
          .select('*')
          .eq('category_id', '1') // Filter for men's products
          .limit(3) // Limit to 3 products for the main carousel
          .order('product_id', ascending: true);

      featuredProducts = response.map<Product>((json) => Product.fromJson(json)).toList();
      print('Fetched ${featuredProducts.length} featured products');
    } catch (e) {
      print('Error fetching featured products: $e');
      featuredProducts = [];
    }
  }

  Future<void> fetchMostWantedProducts() async {
    try {
      final response = await SupabaseConfig.client
          .from('products')
          .select('*')
          .eq('category_id', '1') // Filter for men's products
          .limit(5) // Limit to 5 products for the horizontal list
          .order('product_id', ascending: false); // Newest products first

      mostWantedProducts = response.map<Product>((json) => Product.fromJson(json)).toList();
      print('Fetched ${mostWantedProducts.length} most wanted products');
    } catch (e) {
      print('Error fetching most wanted products: $e');
      mostWantedProducts = [];
    }
  }

  String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    } else {
      return SupabaseConfig.client.storage.from('bid-images').getPublicUrl(imagePath);
    }
  }

  Future<void> loadAllData() async {
    await getUserName();
    await fetchFeaturedProducts();
    await fetchMostWantedProducts();
  }
}