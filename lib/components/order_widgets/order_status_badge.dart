import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color badgeColor;

    switch (status.toUpperCase()) {
      case 'PROCESSING':
        badgeColor = Colors.blue;
        break;
      case 'SHIPPED':
        badgeColor = Colors.orange;
        break;
      case 'DELIVERED':
        badgeColor = Colors.green;
        break;
      case 'CANCELLED':
        badgeColor = Colors.red;
        break;
      case 'RETURNED':
        badgeColor = Colors.purple;
        break;
      case 'RETURN_PENDING':
        badgeColor = Colors.deepPurple;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border.all(color: badgeColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

