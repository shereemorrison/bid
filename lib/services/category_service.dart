import 'package:bid/routes/route.dart';

import '../models/category_model.dart';
import '../supabase/supabase_config.dart';

class CategoryService {
  final _supabase = SupabaseConfig.client;

  // Fetch categories from Supabase
  Future<List<Category>> getCategories() async {
    try {
      // Simulate network delay for testing
      await Future.delayed(const Duration(milliseconds: 800));

      final response = await _supabase
          .from('categories')
          .select('*')
          .order('category_id');

      return response.map<Category>((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e');

      // Fallback to mock data if there's an error
      return [
        Category(
          id: '1',
          name: 'Men',
          route: Paths.shopMen,
        ),
        Category(
          id: '2',
          name: 'Women',
          route: '/shop-women',
        ),
        Category(
          id: '3',
          name: 'Accessories',
          route: '/accessories',
        ),
        Category(
          id: '4',
          name: 'BID Exclusives',
          route: '/bid-exclusives',
        ),
      ];
    }
  }
}

