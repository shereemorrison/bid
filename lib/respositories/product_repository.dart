import 'package:bid/models/product_model.dart';
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ProductRepository extends BaseRepository {
  ProductRepository({SupabaseClient? client}) : super(client: client);

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await client
          .from('products')
          .select('*')
          .order('created_at', ascending: false);

      return (response as List).map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<Product>> getProductsByCategorySlug(String slug) async {
    try {
      print('Fetching products for category slug: $slug');
      final response = await client
          .rpc('get_products_by_slug', params: {
        'slug_param': slug,
        'limit_param': null // No limit
      });

      print('Response from RPC: $response');

      return (response as List).map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching products by category slug: $e');
      print('Error stack trace: ${StackTrace.current}');
      return [];
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await client
          .from('products')
          .select('*')
          .eq('category_id', categoryId)
          .order('created_at', ascending: false);

      return (response as List).map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get product details
  Future<Product?> getProductDetails(String productId) async {
    try {
      final response = await client
          .from('products')
          .select('*')
          .eq('id', productId)
          .single();

      return Product.fromJson(response);
    } catch (e) {
      print('Error fetching product details: $e');
      return null;
    }
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await client
          .from('products')
          .select('*')
          .eq('is_featured', true)
          .order('created_at', ascending: false);

      return (response as List).map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching featured products: $e');
      return [];
    }
  }

  Future<List<Product>> getMostWantedProducts() async {
    try {
      final response = await client
          .from('products')
          .select('*')
          .limit(5)
          .order('created_at', ascending: false);

      return (response as List).map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching most wanted products: $e');
      return [];
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await client
          .from('products')
          .select('*')
          .textSearch('name', query)
          .order('created_at', ascending: false);

      return (response as List).map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
}
