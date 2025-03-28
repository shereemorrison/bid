
import 'package:bid/themes/custom_colors.dart';

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
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length.clamp(0, 4),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(
          context,
          product.name,
          "\$${product.price.toStringAsFixed(2)}",
          getImageUrl(product.imageUrl),
              () => onProductTap(product),
        );
      },
    );
  }

  Widget _buildProductCard(
      BuildContext context,
      String title,
      String price,
      String imageUrl,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              color: Theme.of(context).colorScheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

