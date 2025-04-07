import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/models/order_item_model.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/utils/image_helpers.dart';
import 'package:bid/utils/ui_helpers.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItem item;
  final bool isReturnEligible;
  final bool isSelected;
  final Function(String) onToggleSelection;

  const OrderItemTile({
    Key? key,
    required this.item,
    required this.isReturnEligible,
    required this.isSelected,
    required this.onToggleSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: colorScheme.cardBackground,
      ),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Return checkbox
            if (isReturnEligible)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onToggleSelection(item.itemId),
                activeColor: colorScheme.primary,
              ),

            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? buildProductImage(context, item.imageUrl!, '')
                    : buildPlaceholderImage(context, Icons.image_not_supported),
              ),
            ),

            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    formatPrice(item.price),
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (item.variantName != null)
                        buildAttributeTag("Size: ${item.variantName}", context),
                      const SizedBox(width: 8),
                      buildAttributeTag("Qty: ${item.quantity}", context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

