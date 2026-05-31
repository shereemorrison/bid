import 'package:bid/components/product_widgets/product_list_row.dart';
import 'package:bid/models/order_item_model.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:bid/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItem item;
  final bool isReturnEligible;
  final bool isSelected;
  final Function(String) onToggleSelection;

  const OrderItemTile({
    super.key,
    required this.item,
    required this.isReturnEligible,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final attributeTags = <Widget>[];
    if (item.variantName != null) {
      attributeTags.add(buildAttributeTag('Size: ${item.variantName}', context));
      attributeTags.add(const SizedBox(width: 8));
    }
    attributeTags.add(buildAttributeTag('Qty: ${item.quantity}', context));

    return ProductListRow(
      margin: const EdgeInsets.only(bottom: 12),
      imageSize: 80,
      image: item.imageUrl != null && item.imageUrl!.isNotEmpty
          ? buildProductImage(context, item.imageUrl!, '')
          : buildPlaceholderImage(context, Icons.image_not_supported),
      name: item.name,
      priceText: formatPrice(item.price),
      attributeTags: attributeTags,
      leading: isReturnEligible
          ? Checkbox(
              value: isSelected,
              onChanged: (_) => onToggleSelection(item.itemId),
              activeColor: colorScheme.primary,
            )
          : null,
    );
  }
}
