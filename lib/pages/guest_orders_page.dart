import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Provider for guest orders by email
final guestOrdersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, email) async {
  final service = ref.read(guestOrderServiceProvider);
  return service.getGuestOrdersByEmail(email);
});

class GuestOrdersPage extends ConsumerStatefulWidget {
  const GuestOrdersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GuestOrdersPage> createState() => _GuestOrdersPageState();
}

class _GuestOrdersPageState extends ConsumerState<GuestOrdersPage> {
  final _emailController = TextEditingController();
  bool _hasSearched = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _searchOrders() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _hasSearched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Only fetch orders if user has searched
    final ordersAsync = _hasSearched
        ? ref.watch(guestOrdersProvider(_emailController.text))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email search field
            Text(
              'Find your guest orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the email address you used during checkout',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchOrders,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Results
            if (_hasSearched) ...[
              Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ordersAsync != null ? ordersAsync.when(
                  data: (orders) {
                    if (orders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No orders found for this email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return GuestOrderCard(
                          order: order,
                          onTap: () {
                            // Navigate to order details
                            context.push('/orders/guest/${order['order_id']}');
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Error loading orders: $error',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ) : const Center(
                  child: Text('Search for orders by entering your email'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class GuestOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onTap;

  const GuestOrderCard({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final orderDate = DateTime.parse(order['order_date']);
    final formattedDate = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    final items = order['items'] as List;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
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
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${order['status']}',
                style: TextStyle(
                  color: _getStatusColor(order['status']),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text('${items.length} ${items.length == 1 ? 'item' : 'items'}'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${order['total_amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
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
}
