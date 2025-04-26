
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Provider for a specific guest order
final guestOrderProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, orderId) async {
  final service = ref.read(guestOrderServiceProvider);
  return service.getGuestOrder(orderId);
});

class GuestOrderDetailsPage extends ConsumerWidget {
  final String orderId;

  const GuestOrderDetailsPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(guestOrderProvider(orderId));
    final colorScheme = Theme.of(context).colorScheme;
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return const Center(
              child: Text('Order not found'),
            );
          }

          final items = order['items'] as List;
          final orderDate = DateTime.parse(order['order_date']);
          final formattedDate = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
          final shippingAddress = order['shipping_address'] as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order['order_id'].toString().substring(0, 8)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order['status']).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order['status'],
                                style: TextStyle(
                                  color: _getStatusColor(order['status']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Date: $formattedDate'),
                        const SizedBox(height: 8),
                        Text('Email: ${order['email']}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Items
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Items',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        ...items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              if (item['image_url'] != null)
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      item['image_url'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${item['quantity']} x \$${item['price'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                        const Divider(),
                        _buildOrderSummaryRow('Subtotal', order['total_amount'] - order['tax_amount'] - order['shipping_amount']),
                        _buildOrderSummaryRow('Tax', order['tax_amount']),
                        _buildOrderSummaryRow('Shipping', order['shipping_amount']),
                        const SizedBox(height: 8),
                        _buildOrderSummaryRow('Total', order['total_amount'], isTotal: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Shipping address
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        Text('${shippingAddress['first_name']} ${shippingAddress['last_name']}'),
                        Text(shippingAddress['street_address']),
                        if (shippingAddress['apartment'] != null && shippingAddress['apartment'].isNotEmpty)
                          Text(shippingAddress['apartment']),
                        Text('${shippingAddress['city']}, ${shippingAddress['state']} ${shippingAddress['postal_code']}'),
                        Text(shippingAddress['country']),
                        Text('Phone: ${shippingAddress['phone']}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Payment information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        Text('Method: ${order['payment_method']}'),
                      ],
                    ),
                  ),
                ),

                // Convert to user account button (if logged in)
                if (isLoggedIn && order['converted_to_user_id'] == null) ...[
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _convertOrderToUserAccount(context, ref, order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Add to My Account'),
                  ),
                ],

                // Already converted message
                if (order['converted_to_user_id'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This order has been added to your account',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading order: $error',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'PROCESSING':
        return Colors.blue;
      case 'SHIPPED':
        return Colors.green;
      case 'DELIVERED':
        return Colors.green.shade800;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _convertOrderToUserAccount(BuildContext context, WidgetRef ref, Map<String, dynamic> order) {
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to add this order to your account'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to My Account'),
        content: const Text('Would you like to add this order to your account? This will allow you to track it in your order history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              // Convert the order
              final success = await ref.read(checkoutProvider.notifier).convertGuestOrderToUserOrder(
                order['order_id'],
                userId,
              );

              // Hide loading indicator
              Navigator.of(context).pop();

              // Show result
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Order added to your account successfully'
                        : 'Failed to add order to your account',
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );

              // Refresh the page if successful
              if (success) {
                ref.refresh(guestOrderProvider(orderId));
              }
            },
            child: const Text('Add to My Account'),
          ),
        ],
      ),
    );
  }
}
