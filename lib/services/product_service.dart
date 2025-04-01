

import 'package:bid/models/products_model.dart';
import 'package:bid/supabase/supabase_config.dart';

class ProductService {
  final _supabase = SupabaseConfig.client;

  // Fetch all products from Supabase
  Future<List<Product>> getProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .order('created_at');

      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fetch products by category slug
  Future<List<Product>> getProductsByCategorySlug(String slug) async {
    try {

      final response = await _supabase
          .rpc('get_products_by_slug', params: {
        'slug_param': slug,
        'limit_param': null // No limit
      });

      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products by category slug: $e');
      print('Error stack trace: ${StackTrace.current}');
      return [];
    }
  }

  // Check if a product belongs to a category by slug
  Future<bool> isProductInCategory(String productCategoryId, String categorySlug) async {
    try {
      // Get the category ID for the given slug
      final response = await _supabase
          .from('categories')
          .select('category_id')
          .eq('slug', categorySlug)
          .single();

      // Compare the category IDs
      return response['category_id'].toString() == productCategoryId;
    } catch (e) {
      print('Error checking product category: $e');
      return false;
    }
  }



  // Get public URL for an image in the bid-images bucket
  String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      // If it's already a full URL, return it as is
      return imagePath;
    } else {
      // Otherwise, get the public URL from Supabase storage
      return _supabase.storage.from('bid-images').getPublicUrl(imagePath);
    }
  }
}

