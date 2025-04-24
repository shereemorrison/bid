
import 'package:bid/components/cart_widgets/add_to_cart_section.dart';
import 'package:bid/components/product_widgets/main_product_image.dart';
import 'package:bid/components/product_widgets/product_details_section.dart';
import 'package:bid/components/product_widgets/quantity_selector.dart';
import 'package:bid/components/product_widgets/product_page_size_selector.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:bid/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int quantity = 1;
  String selectedSize = 'M';
  String? selectedColor;
  bool isAccessory = false;
  bool isLoading = true;

  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];

  @override
  void initState() {
    super.initState();
    _checkIfAccessory();
  }

  Future<void> _checkIfAccessory() async {
    // Get the product repository from the provider
    final productRepository = ref.read(productRepositoryProvider);

    // Get the category details for this product
    final categoryId = widget.product.categoryId;

    // Check if the product's category is an accessory category
    try {
      // Get products by category to check if it exists
      final categoryProducts = await productRepository.getProductsByCategory(categoryId);

      // Determine if it's an accessory based on category ID or other logic
      final result = categoryId.toLowerCase().contains('accessory') ||
          categoryId.toLowerCase().contains('accessories');

      if (mounted) {
        setState(() {
          isAccessory = result;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error checking if product is accessory: $e');
    }
  }


  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _selectSize(String size) {
    setState(() {
      selectedSize = size;
    });
  }

  // void _selectColor(Color color) {
  //   setState(() {
  //     selectedColor = color.toString();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(

      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              MainProductImage(imageUrl: widget.product.imageUrl),

              // Product Details
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title and Description
                    ProductDetailsSection(
                      title: widget.product.name,
                      description: widget.product.description,
                    ),

                    const SizedBox(height: 20),

                    // Size Selection
                  if (!isLoading && !isAccessory) ...[
                      SizeSelector(
                        sizes: sizes,
                        selectedSize: selectedSize,
                        onSizeSelected: _selectSize,
                      ),

                      const SizedBox(height: 20),

                    // Quantity Selector
                    QuantitySelector(
                      quantity: quantity,
                      onIncrement: _incrementQuantity,
                      onDecrement: _decrementQuantity,
                    ),
                  ],

                    const SizedBox(height: 20),

                    // Color Selection
                    /*ColorSelector(
                      colors: colors,
                      selectedColor: selectedColor,
                      onColorSelected: _selectColor,
                    ),

                    const SizedBox(height: 32),*/

                    // Add to Cart Button
                    AddToCartSection(
                      product: widget.product,
                      quantity: quantity,
                      selectedSize: selectedSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}