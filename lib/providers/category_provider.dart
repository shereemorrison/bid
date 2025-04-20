// NEW FILE: lib/providers/category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

// Service provider
final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService();
});

// State providers
final categoriesProvider = StateProvider<List<Category>>((ref) => []);
final categoryLoadingProvider = StateProvider<bool>((ref) => false);
final categoryErrorProvider = StateProvider<String?>((ref) => null);

// Controller notifier for complex state management
class CategoryNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final CategoryService _categoryService;

  CategoryNotifier(this._ref, this._categoryService) : super(const AsyncValue.data(null));

  // Load categories
  Future<void> loadCategories() async {
    _ref.read(categoryLoadingProvider.notifier).state = true;
    _ref.read(categoryErrorProvider.notifier).state = null;

    try {
      final categories = await _categoryService.getCategories();
      _ref.read(categoriesProvider.notifier).state = categories;
    } catch (e) {
      _ref.read(categoryErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(categoryLoadingProvider.notifier).state = false;
    }
  }
}

// Provider for the category notifier
final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<void>>((ref) {
  final categoryService = ref.watch(categoryServiceProvider);
  return CategoryNotifier(ref, categoryService);
});
