import 'package:bid/components/order_widgets/order_cost_summary.dart';
import 'package:bid/components/order_widgets/order_product_item.dart';
import 'package:bid/models/product_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/state/cart/cart_state.dart';
import 'package:bid/utils/order_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BagTab extends ConsumerStatefulWidget {
  final VoidCallback onProceed;

  const BagTab({
    Key? key,
    required this.onProceed,
  }) : super(key: key);

  @override
  ConsumerState<BagTab> createState() => _BagTabState();
}

class _BagTabState extends ConsumerState<BagTab> {
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final isLoggedIn = ref.watch(authProvider);
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    // if (cartItems.isEmpty) {
    //   return _buildEmptyCart(colorScheme);
    // }

    // Convert CartItems to Products for the OrderCalculator
    final List<Product> products = cartItems.map((item) =>
        _convertCartItemToProduct(item)).toList();

    // Calculate totals using the converted list
    final double subtotal = OrderCalculator.calculateProductSubtotal(products);
    final double shipping = 10.0;
    final double discount = 0.0;
    final double tax = OrderCalculator.calculateTax(subtotal);
    final double total = OrderCalculator.calculateTotal(
      subtotal: subtotal,
      taxAmount: tax,
      shippingAmount: shipping,
      discountAmount: discount,
    );

    return Column(
      children: [
        // Main content - scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Products section
                Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Display cart items - convert CartItem to Product for OrderProductItem
                ...cartItems.map((item) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OrderProductItem(
                          product: _convertCartItemToProduct(item)),
                    )
                ).toList(),

                const SizedBox(height: 24),

                // Cost summary
                OrderCostSummary(
                  itemsTotal: subtotal,
                  shipping: shipping,
                  tax: tax,
                  total: total,
                ),
              ],
            ),
          ),
        ),

        // Bottom button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.onProceed,
              // Directly proceed without auth check
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                'CONTINUE TO SHIPPING',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to convert CartItem to Product
  Product _convertCartItemToProduct(CartItem item) {
    // Extract size from options if available
    String? selectedSize;
    if (item.options != null && item.options!.containsKey('size')) {
      selectedSize = item.options!['size'] as String?;
    }

    return Product(
      id: item.productId,
      name: item.name,
      price: item.price,
      description: '',
      // Default empty description
      categoryId: '',
      // Default empty categoryId
      isActive: true,
      // Default to active
      createdAt: DateTime.now(),
      // Default to current time
      imageUrl: item.imageUrl ?? '',
      quantity: item.quantity,
      selectedSize: selectedSize,
    );
  }
}

//   // Build empty cart view
//   Widget _buildEmptyCart(ColorScheme colorScheme) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.shopping_cart_outlined,
//             size: 80,
//             color: colorScheme.primary.withOpacity(0.5),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Your cart is empty',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: colorScheme.primary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Add items to your cart to begin checkout',
//             style: TextStyle(
//               fontSize: 16,
//               color: colorScheme.onSurface.withOpacity(0.7),
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to shop
//               Navigator.of(context).pushNamedAndRemoveUntil('/shop', (route) => false);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: colorScheme.primary,
//               foregroundColor: colorScheme.onPrimary,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(0),
//               ),
//             ),
//             child: const Text(
//               'SHOP NOW',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }