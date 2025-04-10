
import 'package:bid/models/order_model.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderHistoryTable extends StatelessWidget {
  final List<Order> orders;
  final Function(String) onViewDetails;

  const OrderHistoryTable({
    Key? key,
    required this.orders,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
            children: [
              // Date column - equal width
              Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Order ID column - equal width
              Expanded(
                child: Text(
                  'Order ID',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Status column - equal width
              Expanded(
                child: Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Empty space for the button column
              SizedBox(width: 80),
            ],
          ),

        Divider(
          color: colorScheme.primary,
          height: 3,
        ),

        // Table rows
        ...orders.map((order) => _buildOrderRow(context, order)).toList(),
      ],
    );
  }

  Widget _buildOrderRow(BuildContext context, Order order) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
        children: [
          // Order date - equal width
          Expanded(
            child: Text(
              formatDate(order.orderDate),
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Order ID - equal width
          Expanded(
            child: Text(
              formatOrderId(order.orderId),
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Status - equal width
          Expanded(
            child: Text(
              order.status,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          // View details button - fixed width
          SizedBox(
            width: 80,
            child: TextButton(
              onPressed: () => context.pushNamed(
                'order_details',
                pathParameters: {'orderId': order.orderId},
              ),
              child: const Text('Details'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
    );
  }
}