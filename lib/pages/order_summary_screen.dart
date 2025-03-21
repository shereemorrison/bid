import 'package:auto_route/annotations.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/providers/shop_provider.dart';

@RoutePage()
class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get cart items from the Shop provider
    final cart = context.watch<Shop>().cart;

    // Calculate totals
    final double itemsTotal = cart.fold(0.0, (sum, item) => sum + item.price);
    final double shipping = 10.0; // You can make this dynamic if needed
    final double tax = itemsTotal * 0.1; // Assuming 10% tax
    final double total = itemsTotal + shipping + tax;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Products from cart
              const Text(
                'Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Display cart items
              ...cart.map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildProductItem(
                  context,
                  product.name,
                  'Size: M ',
                  '\$${product.price.toStringAsFixed(2)}',
                ),
              )).toList(),

              const SizedBox(height: 32),

              // Shipping Information
              const Text(
                'Shipping Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(context,
                'Address',
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Payment Method
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPaymentOption(context, Icons.credit_card, isSelected: true),
                  const SizedBox(width: 12),
                  _buildPaymentOption(context, Icons.add),
                  const SizedBox(width: 12),
                  _buildPaymentOption(context, Icons.person_outline),
                ],
              ),

              const SizedBox(height: 32),

              // Cost Summary
              _buildCostItem('Items', '\$${itemsTotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildCostItem('Shipping', '\$${shipping.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildCostItem('Tax', '\$${tax.toStringAsFixed(2)}'),

              Divider(
                height: 32,
                color: Theme.of(context).colorScheme.primary,
              ),

              _buildCostItem('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),

              const SizedBox(height: 40),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/payment');
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(
      BuildContext context, String title, String subtitle, String price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.quaternary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String text, {required VoidCallback onTap}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.quaternary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'Change',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, IconData icon, {bool isSelected = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.quaternary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white24 : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ]
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildCostItem(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white70,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white70,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

