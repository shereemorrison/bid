import 'dart:async';
import 'package:bid/models/products_model.dart';
import 'package:bid/supabase/supabase_config.dart';


class HomeService {
  String userName = '';
  int currentPage = 0;
  Timer? carouselTimer;

  final List<String> collections = ['Winter', 'Holiday', 'Essentials'];
  List<Product> featuredProducts = [];
  List<Product> mostWantedProducts = [];

  HomeService() {
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
      try {
        final userMetadata = user.userMetadata;
        if (userMetadata != null && userMetadata.containsKey('first_name')) {
          userName = userMetadata['first_name'] as String;
        } else {
          userName = user.email
              ?.split('@')
              .first ?? 'Guest';
        }
      } catch (e) {
        userName = user.email
            ?.split('@')
            .first ?? 'Guest';
      }
    } else {
      userName = 'Guest';
    }
  }

  /*String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'GOOD MORNING';
    } else if (hour < 17) {
      return 'GOOD AFTERNOON';
    } else {
      return 'GOOD EVENING';
    }
  }*/

  Future<List<Product>> fetchFeaturedProducts() async {
    try {
      final response = await SupabaseConfig.client
          .from('products')
          .select('*')
          .eq('is_featured', true)
          .limit(4);

      if (response is List && response.isNotEmpty) {}

      // Convert the response to a List<Product>
      final products = (response as List)
          .map((data) => Product.fromJson(data))
          .toList();

      return products;
    } catch (e) {
      print('Error fetching featured products: $e');
      print('Error stack trace: ${StackTrace.current}');
      return []; // Return empty list on error
    }
  }

  String getCollectionImageUrl(int index) {
    final collections = ['winter', 'holiday', 'essentials'];
    if (index >= 0 && index < collections.length) {
      return getImageUrl('collections/${collections[index]}.jpg');
    }
    return '';
  }

  Future<void> fetchMostWantedProducts() async {
    try {
      final response = await SupabaseConfig.client
          .from('products')
          .select('*')
          .limit(5)
          .order('created_at', ascending: false);

      mostWantedProducts = response.map<Product>((json) => Product.fromJson(json)).toList();
      mostWantedProducts = response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (e) {
      mostWantedProducts = [];
    }
  }

  String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      return '';
    }

    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    return SupabaseConfig.client.storage.from('bid-images').getPublicUrl(imagePath);
  }

  String getHeroImageUrl() {
    return getImageUrl('products/accessories/training.jpg');
  }

  String getOurStoryImageUrl() {
    return getImageUrl('products/accessories/wraps.jpg');
  }


  Future<void> loadAllData() async {
    await getUserName();
    featuredProducts = await fetchFeaturedProducts();
    await fetchMostWantedProducts();
  }
}

