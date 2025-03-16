import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/products_model.dart';
import '../supabase/supabase_config.dart';

class ProductService {
  final _supabase = SupabaseConfig.client;

  // Fetch all products from Supabase
  Future<List<Product>> getProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .order('product_id');

      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fetch products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .eq('category_id', category)
          .order('product_id');

      return response.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
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

