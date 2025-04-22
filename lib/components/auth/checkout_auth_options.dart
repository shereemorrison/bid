import 'package:flutter/material.dart';

enum CheckoutAuthOption {
  login,
  guest,
  register
}

class CheckoutAuthOptions extends StatelessWidget {
  final Function(CheckoutAuthOption) onOptionSelected;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const CheckoutAuthOptions({
    Key? key,
    required this.onOptionSelected,
    this.showCloseButton = false,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.secondary,
          width: 2,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Checkout Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
                if (showCloseButton && onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              context: context,
              icon: Icons.login,
              label: 'Sign In',
              description: 'Already have an account? Sign in for a faster checkout',
              onTap: () => onOptionSelected(CheckoutAuthOption.login),
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              context: context,
              icon: Icons.person_add_outlined,
              label: 'Create Account',
              description: 'Create an account to track orders and save your details',
              onTap: () => onOptionSelected(CheckoutAuthOption.register),
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              context: context,
              icon: Icons.shopping_bag_outlined,
              label: 'Checkout as Guest',
              description: 'Continue without creating an account',
              onTap: () => onOptionSelected(CheckoutAuthOption.guest),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.secondary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.secondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
