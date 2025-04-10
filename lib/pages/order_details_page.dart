import 'package:bid/components/cards/order_info_card.dart';
import 'package:bid/components/common_widgets/empty_state.dart';
import 'package:bid/components/order_widgets/order_cost_summary.dart';
import 'package:bid/components/order_widgets/order_item_tile.dart';
import 'package:bid/components/order_widgets/order_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/models/order_model.dart';
import 'package:bid/providers/order_provider.dart';
import 'package:bid/services/order_service.dart';
import 'package:bid/utils/order_helpers.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/components/buttons/shopping_buttons.dart';


class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final OrderService _orderService = OrderService();
  Set<String> _selectedItemsForReturn = {};
  bool _isSubmittingReturn = false;

  @override
  void initState() {
    super.initState();
    // Fetch order details when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrderDetails(widget.orderId);
    });
  }

  // Toggle item selection for return
  void _toggleItemSelection(String itemId) {
    setState(() {
      if (_selectedItemsForReturn.contains(itemId)) {
        _selectedItemsForReturn.remove(itemId);
      } else {
        _selectedItemsForReturn.add(itemId);
      }
    });
  }

  // Submit return request to Supabase
  Future<void> _submitReturn() async {
    if (_selectedItemsForReturn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item to return')),
      );
      return;
    }

    setState(() {
      _isSubmittingReturn = true;
    });

    try {
      // Submit return request to Supabase
      await _orderService.initiateReturn(widget.orderId, _selectedItemsForReturn.toList());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Return request submitted successfully')),
      );

      // Refresh order details to show updated status
      Provider.of<OrderProvider>(context, listen: false).fetchOrderDetails(widget.orderId);

      // Clear selection
      setState(() {
        _selectedItemsForReturn = {};
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit return: $e')),
      );
    } finally {
      setState(() {
        _isSubmittingReturn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.error != null) {
            return EmptyState(
              icon: Icons.error_outline,
              title: 'Error Loading Order',
              subtitle: orderProvider.error ?? 'An unknown error occurred',
            );
          }

          final order = orderProvider.selectedOrder;
          if (order == null) {
            return const EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Order Not Found',
              subtitle: 'We couldn\'t find the order you\'re looking for',
            );
          }

          // Check if order is eligible for returns
          final bool isReturnEligible = isOrderReturnEligible(order);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(context, order),
                  const SizedBox(height: 24),
                  _buildOrderItems(context, order, isReturnEligible),
                  const SizedBox(height: 24),
                  OrderCostSummary(
                    itemsTotal: order.subtotal,
                    shipping: order.shipping_amount,
                    tax: order.taxAmount,
                    total: order.totalAmount,
                  ),
                  const SizedBox(height: 24),
                  if (isReturnEligible && _selectedItemsForReturn.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: BaseStyledButton(
                        text: "INITIATE RETURN",
                        onTap: _isSubmittingReturn ? null : _submitReturn,
                        height: 50,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatOrderId(order.orderId),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            StatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: 16),
        OrderInfoCard(
          text: 'Placed on ${formatDate(order.orderDate)}',
          onTap: () {}, // No action needed for this info card
        ),
        if (order.shippedAt != null) ...[
          const SizedBox(height: 8),
          OrderInfoCard(
            text: 'Shipped on ${formatDate(order.shippedAt!)}',
            onTap: () {}, // No action needed for this info card
          ),
        ],
        if (order.deliveredAt != null) ...[
          const SizedBox(height: 8),
          OrderInfoCard(
            text: 'Delivered on ${formatDate(order.deliveredAt!)}',
            onTap: () {}, // No action needed for this info card
          ),
        ],
        if (order.trackingNumber != null) ...[
          const SizedBox(height: 8),
          OrderInfoCard(
            text: 'Tracking: ${order.trackingNumber!}',
            onTap: () {}, // Could open tracking website in the future
          ),
        ],
      ],
    );
  }

  Widget _buildOrderItems(BuildContext context, Order order, bool isReturnEligible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...order.items.map((item) => OrderItemTile(
          item: item,
          isReturnEligible: isReturnEligible,
          isSelected: _selectedItemsForReturn.contains(item.itemId),
          onToggleSelection: _toggleItemSelection,
        )),
      ],
    );
  }
}