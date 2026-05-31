import 'package:bid/components/cards/order_info_card.dart';
import 'package:bid/components/cart_widgets/empty_state.dart';
import 'package:bid/components/order_widgets/order_cost_summary.dart';
import 'package:bid/components/order_widgets/order_item_tile.dart';
import 'package:bid/components/order_widgets/order_status_badge.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bid/models/order_model.dart';
import 'package:bid/utils/order_helpers.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:bid/components/buttons/shopping_buttons.dart';

class OrderDetailsPage extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  Set<String> _selectedItemsForReturn = {};
  bool _isSubmittingReturn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).fetchOrderDetails(widget.orderId);
    });
  }

  void _toggleItemSelection(String itemId) {
    setState(() {
      if (_selectedItemsForReturn.contains(itemId)) {
        _selectedItemsForReturn.remove(itemId);
      } else {
        _selectedItemsForReturn.add(itemId);
      }
    });
  }

  Future<void> _submitReturn() async {
    if (_selectedItemsForReturn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one item to return'),
        ),
      );
      return;
    }

    setState(() => _isSubmittingReturn = true);

    try {
      await ref
          .read(ordersProvider.notifier)
          .initiateReturn(widget.orderId, _selectedItemsForReturn.toList());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Return request submitted successfully')),
      );

      ref.read(ordersProvider.notifier).fetchOrderDetails(widget.orderId);
      setState(() => _selectedItemsForReturn = {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit return: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmittingReturn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final selectedOrder = ordersState.selectedOrder;
    final isLoading = ordersState.isLoading && selectedOrder == null;
    final error = ordersState.error;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && selectedOrder == null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Error Loading Order',
        subtitle: error,
      );
    }

    if (selectedOrder == null) {
      return const EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'Order Not Found',
        subtitle: 'We couldn\'t find the order you\'re looking for',
      );
    }

    final isReturnEligible = isOrderReturnEligible(selectedOrder);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(context, selectedOrder),
            const SizedBox(height: 24),
            _buildOrderItems(context, selectedOrder, isReturnEligible),
            const SizedBox(height: 24),
            OrderCostSummary(
              itemsTotal: selectedOrder.subtotal,
              shipping: selectedOrder.shippingAmount,
              tax: selectedOrder.taxAmount,
              total: selectedOrder.totalAmount,
            ),
            const SizedBox(height: 24),
            if (isReturnEligible && _selectedItemsForReturn.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: BaseStyledButton(
                  text: 'INITIATE RETURN',
                  onTap: _isSubmittingReturn ? null : _submitReturn,
                  height: 50,
                  fontSize: 16,
                ),
              ),
          ],
        ),
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
            Expanded(
              child: Text(
                formatOrderId(order.orderId),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            StatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: 16),
        OrderInfoCard(
          text: 'Placed on ${formatDate(order.orderDate)}',
          onTap: () {},
        ),
        if (order.shippedAt != null) ...[
          const SizedBox(height: 8),
          OrderInfoCard(
            text: 'Shipped on ${formatDate(order.shippedAt!)}',
            onTap: () {},
          ),
        ],
        if (order.deliveredAt != null) ...[
          const SizedBox(height: 8),
          OrderInfoCard(
            text: 'Delivered on ${formatDate(order.deliveredAt!)}',
            onTap: () {},
          ),
        ],
        if (order.trackingNumber != null) ...[
          const SizedBox(height: 8),
          OrderInfoCard(
            text: 'Tracking: ${order.trackingNumber!}',
            onTap: () {},
          ),
        ],
      ],
    );
  }

  Widget _buildOrderItems(
    BuildContext context,
    Order order,
    bool isReturnEligible,
  ) {
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
        ...order.items.map(
          (item) => OrderItemTile(
            item: item,
            isReturnEligible: isReturnEligible,
            isSelected: _selectedItemsForReturn.contains(item.itemId),
            onToggleSelection: _toggleItemSelection,
          ),
        ),
      ],
    );
  }
}
