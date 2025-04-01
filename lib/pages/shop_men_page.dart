
import 'package:bid/models/products_model.dart';
import 'package:bid/services/product_service.dart';
import 'package:bid/utils/page_helpers.dart';
import 'package:flutter/material.dart';


class ShopMenPage extends StatefulWidget {
  const ShopMenPage({super.key});

  @override
  _ShopMenPageState createState() => _ShopMenPageState();
}

class _ShopMenPageState extends State<ShopMenPage> {
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
      final products = await _productService.getProductsByCategorySlug('men');

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
          "Shop Men",
          _products,
          _isLoading,
          _error,
          _loadProducts
      ),
    );
  }
}

