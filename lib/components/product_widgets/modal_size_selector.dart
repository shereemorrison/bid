import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showSizeSelectorModal(BuildContext context, Product product) {
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL',];
  String? selectedSize;
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    backgroundColor: colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: sizes.map((size) {
                    final isSelected = selectedSize == size;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AddToCartButton(
                    onTap: selectedSize == null ? null : () {
                      // Add to cart with selected size
                      final productWithSize = product.copyWith(
                        selectedSize: selectedSize,
                      );
                      context.read<Shop>().addToCart(productWithSize);
                      DialogService.showAddToCartDialog(context, productWithSize);
                      Navigator.pop(context);
                    },
                    height: 50,
                    fontSize: 16,
                    width: double.infinity,
                    text: 'Add to Cart',
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}