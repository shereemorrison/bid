


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
          .select('*');

      List<Category> categories = response.map<Category>((json) => Category.fromJson(json)).toList();
      final customOrder = ['men', 'women', 'accessories', 'sale', 'bid exclusives'];

      categories.sort((a, b) {
      int indexA = customOrder.indexOf(a.name.toLowerCase());
      int indexB = customOrder.indexOf(b.name.toLowerCase());

      if (indexA == -1) indexA = customOrder.length;
      if (indexB == -1) indexB = customOrder.length;

      return indexA.compareTo(indexB);
    });


      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}

