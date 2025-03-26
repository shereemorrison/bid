import 'package:bid/routes/route.dart';

import '../models/category_model.dart';
import '../supabase/supabase_config.dart';

class CategoryService {
  final _supabase = SupabaseConfig.client;

  // Fetch categories from Supabase
  Future<List<Category>> getCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final response = await _supabase
          .from('categories')
          .select('*')
          .order('created_at', ascending: true);

      return response.map<Category>((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e');

      // Fallback if error - TODO - Test to see if this can now be removed
      return [
        Category(
          id: '1',
          name: 'Men',
          route: Paths.shopMen,
        ),
      ];
    }
  }
}

