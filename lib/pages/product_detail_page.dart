
import 'package:bid/components/cart_widgets/add_to_cart_section.dart';
import 'package:bid/components/product_widgets/color_selector.dart';
import 'package:bid/components/product_widgets/main_product_image.dart';
import 'package:bid/components/product_widgets/product_details_section.dart';
import 'package:bid/components/product_widgets/quantity_selector.dart';
import 'package:bid/components/product_widgets/size_selector.dart';
import 'package:flutter/material.dart';
import 'package:bid/models/products_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  String? selectedSize;
  String? selectedColor;

  // Available sizes
  final List<String> sizes = ['S', 'M', 'L', 'XL'];

  final List<Color> colors = [
    Colors.black,
    Colors.white70,
    Colors.grey.shade700,
  ];

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

  void _selectColor(Color color) {
    setState(() {
      selectedColor = color.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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

                    const SizedBox(height: 24),

                    // Quantity Selector
                    QuantitySelector(
                      quantity: quantity,
                      onIncrement: _incrementQuantity,
                      onDecrement: _decrementQuantity,
                    ),

                    const SizedBox(height: 24),

                    // Size Selection
                    SizeSelector(
                      sizes: sizes,
                      selectedSize: selectedSize,
                      onSizeSelected: _selectSize,
                    ),

                    const SizedBox(height: 24),

                    // Color Selection
                    ColorSelector(
                      colors: colors,
                      selectedColor: selectedColor,
                      onColorSelected: _selectColor,
                    ),

                    const SizedBox(height: 32),

                    // Add to Cart Button
                    AddToCartSection(
                      product: widget.product,
                      quantity: quantity,
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