
import 'package:auto_route/annotations.dart';
import 'package:auto_route/annotations.dart';
import 'package:bid/components/cards/shop_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/widgets/product_grid_item.dart';
import '../components/widgets/search_bar.dart';
import '../models/products_model.dart';
import '../providers/shop_provider.dart';
import '../services/product_service.dart';

@RoutePage()
class ShopWomenPage extends StatefulWidget {

  const ShopWomenPage({super.key});

  @override
  State<ShopWomenPage> createState() => _ShopWomenPageState();
}

class _ShopWomenPageState extends State<ShopWomenPage> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get men's products from Supabase
      final products = await _productService.getProductsByCategorySlug('women');

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Text(
                "Shop Women",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              const CustomSearchBar(),
              const SizedBox(height: 24),

              // All Products Section
              Text(
                "All Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 12),

              // Grid of Products
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
                    : _products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : RefreshIndicator(
                  onRefresh: _loadProducts,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return ProductGridItem(product: _products[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
