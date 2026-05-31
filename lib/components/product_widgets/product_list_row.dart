import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

/// Shared horizontal product row used in cart, wishlist, and order lists.
class ProductListRow extends StatelessWidget {
  final Widget image;
  final String name;
  final String priceText;
  final List<Widget>? attributeTags;
  final Widget? trailing;
  final Widget? leading;
  final Widget? footer;
  final EdgeInsets padding;
  final double imageSize;
  final EdgeInsetsGeometry? margin;

  const ProductListRow({
    super.key,
    required this.image,
    required this.name,
    required this.priceText,
    this.attributeTags,
    this.trailing,
    this.leading,
    this.footer,
    this.padding = const EdgeInsets.all(12),
    this.imageSize = 100,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: colorScheme.cardBackground,
      ),
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) leading!,
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: image,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priceText,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (attributeTags != null && attributeTags!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(children: attributeTags!),
                  ],
                  if (footer != null) ...[
                    const SizedBox(height: 12),
                    footer!,
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
