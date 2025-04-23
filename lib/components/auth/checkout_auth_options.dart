import 'package:flutter/material.dart';

/// Options for checkout authentication
enum CheckoutAuthOption {
  login,
  register,
  guest,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with optional close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Checkout Options',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            if (showCloseButton)
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.primary),
                onPressed: onClose,
              ),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          'Please select how you would like to proceed:',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 30),

        // Login option
        _buildOptionButton(
          context: context,
          icon: Icons.login,
          label: 'Login',
          description: 'Sign in with your existing account',
          onTap: () => onOptionSelected(CheckoutAuthOption.login),
        ),

        const SizedBox(height: 15),

        // Register option
        _buildOptionButton(
          context: context,
          icon: Icons.person_add,
          label: 'Register',
          description: 'Create a new account',
          onTap: () => onOptionSelected(CheckoutAuthOption.register),
        ),

        const SizedBox(height: 15),

        // Guest checkout option
        _buildOptionButton(
          context: context,
          icon: Icons.shopping_bag,
          label: 'Guest Checkout',
          description: 'Continue without an account',
          onTap: () => onOptionSelected(CheckoutAuthOption.guest),
        ),
      ],
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
          border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 24),
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
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: colorScheme.primary, size: 16),
          ],
        ),
      ),
    );
  }
}
