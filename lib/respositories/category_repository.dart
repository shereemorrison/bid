import 'package:bid/models/category_model.dart' as app_category;
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository extends BaseRepository {
  CategoryRepository({SupabaseClient? client}) : super(client: client);

  // Get all categories
  Future<List<app_category.Category>> getAllCategories() async {
    try {
      final response = await client
          .from('categories')
          .select('*')
          .order('name', ascending: true);

      return (response as List).map((data) => app_category.Category.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Get category by ID
  Future<app_category.Category?> getCategoryById(String categoryId) async {
    try {
      final response = await client
          .from('categories')
          .select('*')
          .eq('id', categoryId)
          .single();

      return app_category.Category.fromJson(response);
    } catch (e) {
      print('Error fetching category: $e');
      return null;
    }
  }

  // Get category by slug
  Future<app_category.Category?> getCategoryBySlug(String slug) async {
    try {
      final response = await client
          .from('categories')
          .select('*')
          .eq('slug', slug)
          .single();

      return app_category.Category.fromJson(response);
    } catch (e) {
      print('Error fetching category by slug: $e');
      return null;
    }
  }
}
