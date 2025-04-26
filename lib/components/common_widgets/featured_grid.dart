
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/product_helpers.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<dynamic> products;
  final Function(String) getImageUrl;
  final Function(dynamic) onProductTap;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.getImageUrl,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length.clamp(0, 4),
      itemBuilder: (context, index) {
        final product = products[index];
        return buildProductCard(
          context,
          product.name,
          formatPrice(product.price),
          getImageUrl(product.imageUrl),
              () => onProductTap(product),
        );
      },
    );
  }
}
