import 'package:bid/models/category_model.dart' as app_category;
import 'package:bid/models/product_model.dart';
import 'package:bid/repositories/base_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository extends BaseRepository {
  ProductRepository({SupabaseClient? client}) : super(client: client);

  Future<List<app_category.Category>> getAllCategories() async {
    try {
      final response = await client
          .from('categories')
          .select('*')
          .order('sort_order', ascending: true);

      return (response as List)
          .map((data) => app_category.Category.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

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

  Future<app_category.Category?> getCategoryBySlug(String slug) async {
    try {
      final response =
          await client.from('categories').select('*').eq('slug', slug).single();

      return app_category.Category.fromJson(response);
    } catch (e) {
      print('Error fetching category by slug: $e');
      return null;
    }
  }

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
          .eq('product_id', productId)
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
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List).map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching featured products: $e');
      return [];
    }
  }

  /// One preview product per shop category for the home COLLECTIONS row.
  Future<List<Product>> getCollectionPreviewProducts() async {
    const slugs = ['men', 'women', 'accessories', 'sale'];

    try {
      final categories = await getAllCategories();
      final products = <Product>[];

      for (final slug in slugs) {
        final category = categories.where((c) => c.slug == slug).firstOrNull;
        if (category == null) continue;

        final response = await client
            .from('products')
            .select('*')
            .eq('category_id', category.id)
            .eq('is_active', true)
            .order('is_featured', ascending: false)
            .order('created_at', ascending: false)
            .limit(1);

        if ((response as List).isNotEmpty) {
          products.add(Product.fromJson(response.first));
        }
      }

      if (products.length >= 4) return products.take(4).toList();

      // Top up from featured/active products when a category is empty (e.g. sale).
      final featured = await getFeaturedProducts();
      for (final product in featured) {
        if (products.length >= 4) break;
        if (products.any((p) => p.id == product.id)) continue;
        products.add(product);
      }

      if (products.length >= 4) return products.take(4).toList();

      final active = await client
          .from('products')
          .select('*')
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(12);

      for (final row in active as List) {
        if (products.length >= 4) break;
        final product = Product.fromJson(row);
        if (products.any((p) => p.id == product.id)) continue;
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error fetching collection preview products: $e');
      return [];
    }
  }

  Future<List<Product>> getMostWantedProducts() async {
    try {
      // Prefer an explicit "most wanted" flag when available in schema.
      try {
        final flagged = await client
            .from('products')
            .select('*')
            .eq('is_most_wanted', true)
            .limit(8)
            .order('created_at', ascending: false);
        final flaggedProducts =
            (flagged as List).map((data) => Product.fromJson(data)).toList();
        if (flaggedProducts.isNotEmpty) return flaggedProducts;
      } catch (_) {
        // Ignore if column doesn't exist; fallback below.
      }

      final response = await client
          .from('products')
          .select('*')
          .eq('is_active', true)
          .limit(8)
          .order('is_featured', ascending: false)
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
