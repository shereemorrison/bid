// NEW FILE: lib/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/products_model.dart';
import '../services/home_service.dart';

// Service provider
final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeService();
});

// State providers
final featuredProductsProvider = StateProvider<List<Product>>((ref) => []);
final mostWantedProductsProvider = StateProvider<List<Product>>((ref) => []);
final homeLoadingProvider = StateProvider<bool>((ref) => false);
final homeErrorProvider = StateProvider<String?>((ref) => null);
final currentPageProvider = StateProvider<int>((ref) => 0);

// Controller notifier for complex state management
class HomeNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final HomeService _homeService;

  HomeNotifier(this._ref, this._homeService) : super(const AsyncValue.data(null));

  // Load all home data
  Future<void> loadAllData() async {
    _ref.read(homeLoadingProvider.notifier).state = true;
    _ref.read(homeErrorProvider.notifier).state = null;

    try {
      await _homeService.loadAllData();
      _ref.read(featuredProductsProvider.notifier).state = _homeService.featuredProducts;
      _ref.read(mostWantedProductsProvider.notifier).state = _homeService.mostWantedProducts;
    } catch (e) {
      _ref.read(homeErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(homeLoadingProvider.notifier).state = false;
    }
  }

  // Get image URLs
  String getHeroImageUrl() => _homeService.getHeroImageUrl();
  String getOurStoryImageUrl() => _homeService.getOurStoryImageUrl();
  String getImageUrl(String path) => _homeService.getImageUrl(path);
  String getCollectionImageUrl(int index) => _homeService.getCollectionImageUrl(index);

  // Update current page
  void updateCurrentPage(int page) {
    _ref.read(currentPageProvider.notifier).state = page;
  }

  // Dispose
  void disposeService() {
    _homeService.dispose();
  }
}

// Provider for the home notifier
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, AsyncValue<void>>((ref) {
  final homeService = ref.watch(homeServiceProvider);
  return HomeNotifier(ref, homeService);
});
