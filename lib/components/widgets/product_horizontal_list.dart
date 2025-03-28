
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/products_model.dart';

class ProductHorizontalList extends StatelessWidget {
  final List<Product>? products;
  final String Function(String)? getImageUrl;

  const ProductHorizontalList({
    super.key,
    required this.products,
    required this.getImageUrl,
  });

  @override
  Widget build(BuildContext context) {

    final bool useProducts = products != null && products!.isNotEmpty && getImageUrl != null;
    final int itemCount = useProducts ? products!.length : 5;

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {

          final Product? product = useProducts && index < products!.length ? products![index] : null;

          String? imageUrl;
          if (useProducts && product != null && getImageUrl != null) {
            imageUrl = getImageUrl!(product.imageUrl);
          }

          return GestureDetector(
              onTap: () {
                if (product != null) {
                  context.push('/shop/product', extra: product);
                }
              },

          child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.cardBackground,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Theme.of(context).colorScheme.textSecondary,
                          ),
                        );
                      },
                    )
                        : const Center(
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        useProducts && product != null ? product.name : 'Product ${index + 1}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        useProducts && product != null
                            ? '\$${product.price.toStringAsFixed(2)}'
                            : '\$${(index + 1) * 100}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          );
        },
      ),
    );
  }
}

