import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/components/product_widgets/modal_size_selector.dart';
import 'package:bid/components/product_widgets/product_list_row.dart';
import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistItemCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(cartProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return ProductListRow(
      image: buildProductImage(context, product.imageUrl, product.imagePath),
      name: product.name,
      priceText: formatPrice(product.price),
      footer: AddToCartButton(
        onTap: () => showSizeSelectorModal(context, product, ref),
        height: 30,
        fontSize: 10,
        width: 120,
      ),
      trailing: CustomIconButton(
        icon: Icons.close,
        onTap: onRemove,
        size: 30,
        iconSize: 20,
        iconColor: colorScheme.textSecondary,
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
      ),
    );
  }
}
