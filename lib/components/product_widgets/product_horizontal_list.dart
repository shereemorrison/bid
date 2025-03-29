
import 'package:bid/models/products_model.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              color: colorScheme.cardBackground,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                                child: imageUrl != null
                                    ? buildProductImage(context, imageUrl, '')
                                    : buildPlaceholderImage(context, Icons.image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        useProducts && product != null ? product.name : 'Product ${index + 1}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        useProducts && product != null
                            ? formatPrice(product.price)
                            : formatPrice((index + 1) * 100.0),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.accent,
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

