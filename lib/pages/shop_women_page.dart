
import 'package:bid/components/common_widgets/search_bar.dart';
import 'package:bid/components/product_widgets/product_grid_item.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/services/product_service.dart';
import 'package:bid/utils/page_helpers.dart';
import 'package:flutter/material.dart';


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

      // Get products from Supabase
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
      body: buildShopPageLayout(
          context,
          "Shop Women",
          _products,
          _isLoading,
          _error,
          _loadProducts
      ),
    );
  }
}
