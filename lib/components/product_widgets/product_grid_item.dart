
import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/dialog_service.dart';
import 'package:bid/services/product_service.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'modal_size_selector.dart';


class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({
    super.key,
    required this.product,
  });



  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
        onTap: () {
          // Navigate to product detail page
          context.push('/shop/product', extra: product);
        },

        child: Card(
          color: colorScheme.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(0)),
                      child: buildProductImage(
                          context, product.imageUrl, product.imagePath),
                    ),
                  ),

                  // Wishlist Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border, color: Colors.white,),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          context.read<Shop>().addToWishlist(product);
                          DialogService.showAddToWishlistDialog(
                              context, product);
                        },
                        constraints: const BoxConstraints.tightFor(
                            width: 25, height: 25),
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                      ),
                    ),
                  ),
                ],
              ),

              // Product Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.name,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            formatPrice(product.price),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.accent,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add to Cart Button
                    /*Expanded(
                      child: AddToCartButton(
                        onTap: () {
                          context.read<Shop>().addToCart(product);
                          DialogService.showAddToCartDialog(context, product);
                        },
                        height: 30,
                        fontSize: 10,
                      ),
                    ),*/

                    // Add to Cart Icon
                    Container(
                      width: 25,
                      height: 25,
                      margin: const EdgeInsets.only(right: 0, top: 8),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: () => showSizeSelectorModal(context, product),
                        constraints: const BoxConstraints.tightFor(
                            width: 25, height: 25),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

