import 'package:flutter/material.dart';
import '../../models/products_model.dart';

class ProductHorizontalList extends StatelessWidget {
  final Color customBeige;
  final List<Product>? products;
  final String Function(String)? getImageUrl;

  const ProductHorizontalList({
    super.key,
    required this.customBeige,
    required this.products,
    required this.getImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final greyShade300 = Colors.grey.shade300;

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

          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return const Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
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
                        style: TextStyle(
                          color: greyShade300,
                          fontSize: 14,
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
                        style: TextStyle(
                          color: customBeige,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

