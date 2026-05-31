import 'package:flutter/material.dart';

enum AppButtonStyle { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool isFullWidth;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isFullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (style) {
      case AppButtonStyle.primary:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        border = null;
        break;
      case AppButtonStyle.secondary:
        backgroundColor = colorScheme.secondary;
        textColor = colorScheme.onSecondary;
        border = null;
        break;
      case AppButtonStyle.outline:
        backgroundColor = Colors.transparent;
        textColor = colorScheme.secondary;
        border = Border.all(color: colorScheme.secondary);
        break;
    }

    Widget button = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: border,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1.0,
        child: button,
      ),
    );
  }
}
