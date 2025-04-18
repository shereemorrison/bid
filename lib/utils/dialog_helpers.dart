import 'package:flutter/material.dart';

// Helper class to define button properties
class DialogButton {
  final String text;
  final dynamic returnValue;
  final Color? color;
  final Color? backgroundColor;

  DialogButton({
    required this.text,
    this.returnValue,
    this.color,
    this.backgroundColor,
  });
}

// Helper method to build buttons row
Widget buildDialogButtonsRow(
    BuildContext context,
    List<DialogButton> buttons,
    Color defaultColor,
    ) {
  if (buttons.length == 1) {
    // Single button takes full width
    return SizedBox(
      width: double.infinity,
      child: buildDialogButton(context, buttons[0], defaultColor),
    );
  } else {
    // Multiple buttons in a row
    return Row(
      children: buttons.asMap().entries.map((entry) {
        final index = entry.key;
        final button = entry.value;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: buildDialogButton(context, button, defaultColor)),
              if (index < buttons.length - 1) const SizedBox(width: 12),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Helper method to build a single button
Widget buildDialogButton(
    BuildContext context,
    DialogButton button,
    Color defaultColor,
    ) {
  final buttonColor = button.color ?? defaultColor;

  return OutlinedButton(
    onPressed: () {
      if (button.returnValue != null) {
        Navigator.pop(context, button.returnValue);
      } else {
        Navigator.pop(context);
      }
    },
    style: OutlinedButton.styleFrom(
      backgroundColor: button.backgroundColor ?? Colors.transparent,
      foregroundColor: buttonColor,
      side: BorderSide(color: buttonColor, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
    child: Text(
      button.text.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    ),
  );
}