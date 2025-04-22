import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckoutButton extends ConsumerWidget {
  final String text;
  final Color textColor;
  final Color borderColor;
  final double amount;

  const CheckoutButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.borderColor,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: () => _navigateToCheckout(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  void _navigateToCheckout(BuildContext context) {
    // Navigate to the tabbed checkout page
    context.push('/cart/checkout');
  }
}
