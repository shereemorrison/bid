import 'package:flutter/material.dart';
import 'dart:math' as Math;
import '../../models/order_model.dart';

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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // Order ID column - equal width
              Expanded(
                child: Text(
                  'Order ID',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // Status column - equal width
              Expanded(
                child: Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // Empty space for the button column
              SizedBox(width: 80),
            ],
          ),

        Divider(
          color: Theme.of(context).colorScheme.primary,
          height: 3,
        ),

        // Table rows
        ...orders.map((order) => _buildOrderRow(context, order)).toList(),
      ],
    );
  }

  Widget _buildOrderRow(BuildContext context, Order order) {
    return Row(
        children: [
          // Order date - equal width
          Expanded(
            child: Text(
              '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Order ID - equal width
          Expanded(
            child: Text(
              '#${order.orderId.substring(0, Math.min(8, order.orderId.length))}',
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
                  color: Theme.of(context).colorScheme.primary
              ),
            ),
          ),

          // View details button - fixed width
          SizedBox(
            width: 80,
            child: TextButton(
              onPressed: () => onViewDetails(order.orderId),
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