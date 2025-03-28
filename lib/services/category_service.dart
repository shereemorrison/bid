


import 'package:bid/models/category_model.dart';
import 'package:bid/supabase/supabase_config.dart';

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
      return [];
    }
  }
}

