import 'package:bid/models/product_model.dart';
import 'package:bid/themes/custom_colors.dart';
import 'package:bid/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';


class DialogService {
  static Future<T?> _showBaseDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<DialogButton> buttons,
    Color? borderColor,

  }) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dialogBorderColor = borderColor ?? colorScheme.accent;

    return showDialog<T>(
      context: context,
      builder: (context) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.accent,
                width: 2,
              ),
            ),
            backgroundColor: colorScheme.surface, // Dark background
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.accent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary, // White text
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  buildDialogButtonsRow(context, buttons, dialogBorderColor),
                ],
              ),
            ),
          ),
    );
  }
// Confirmation dialog with customizable buttons
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    bool isDestructive = false,
  }) async {
    final buttons = <DialogButton>[];

    if (cancelText.isNotEmpty) {
      buttons.add(DialogButton(
        text: cancelText,
        returnValue: false,
      ));
    }

    if (confirmText.isNotEmpty) {
      buttons.add(DialogButton(
        text: confirmText,
        returnValue: true,
        color: isDestructive ? Colors.red.shade300 : null,
        backgroundColor: isDestructive ? Colors.red : null,
      ));
    }

    return _showBaseDialog<bool>(
      context: context,
      title: title,
      content: content,
      buttons: buttons,
    );
  }

  // Generic notification dialog with OK button
  static Future<void> showNotificationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'OK',
    Color? borderColor,
  }) async {
    return _showBaseDialog(
      context: context,
      title: title,
      content: content,
      buttons: [DialogButton(text: buttonText)],
      borderColor: borderColor,
    );
  }

  // Add to cart Dialog
  static void showAddToCartDialog(BuildContext context, Product product) {
    showNotificationDialog(
      context: context,
      title: "Added to Cart",
      content: "${product.name} has been added to your cart",
    );
  }

  // Add to wishlist dialog
  static void showAddToWishlistDialog(BuildContext context, Product product) {
    showNotificationDialog(
      context: context,
      title: "Added to Wishlist",
      content: "${product.name} has been added to your wishlist",
    );
  }

  // Removed from cart dialog
  static void showRemoveFromCartDialog(BuildContext context, Product product) {
    final colorScheme = Theme.of(context).colorScheme;

    showNotificationDialog(
      context: context,
      title: "Removed from Cart",
      content: "${product.name} has been removed from your cart",
      borderColor: colorScheme.secondary,
    );
  }

  // Removed from wishlist dialog
  static void showRemoveFromWishlistDialog(BuildContext context, Product product) {
    final colorScheme = Theme.of(context).colorScheme;

    showNotificationDialog(
      context: context,
      title: "Removed from Wishlist",
      content: "${product.name} has been removed from your wishlist",
      borderColor: colorScheme.secondary,
    );
  }

  // Newsletter subscription confirmation dialog
  static void showNewsletterSubscriptionDialog(BuildContext context, String email) {
    showNotificationDialog(
      context: context,
      title: "Subscription Confirmed",
      content: "Thank you! $email has been successfully subscribed to our newsletter.",
    );
  }
}