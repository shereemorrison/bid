import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class BaseStyledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;

  const BaseStyledButton({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
    this.borderColor,
    this.width,
    this.height = 45,
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? Theme.of(context).colorScheme.accent,
          side: BorderSide(color: borderColor ?? Theme.of(context).colorScheme.accent, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Square corners
          ),

          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shop Now button
class ShopNowButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double height;
  final double fontSize;

  const ShopNowButton({
    super.key,
    this.onTap,
    this.textColor,
    this.borderColor,
    this.width,
    this.height = 45,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return BaseStyledButton(
      text: "SHOP NOW",
      onTap: onTap,
      textColor: textColor,
      borderColor: borderColor,
      width: width,
      height: height,
      fontSize: fontSize,
    );
  }
}

/// Add to Cart button
class AddToCartButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double height;
  final double fontSize;

  const AddToCartButton({
    super.key,
    this.text = "ADD TO CART",
    this.onTap,
    this.textColor,
    this.borderColor,
    this.width,
    this.height = 45,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return BaseStyledButton(
      text: text,
      onTap: onTap,
      textColor: textColor,
      borderColor: borderColor,
      width: width,
      height: height,
      fontSize: fontSize,
    );
  }
}

/// Icon button
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double size;
  final double iconSize;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.backgroundColor = Colors.transparent,
    this.iconColor,
    this.borderColor,
    this.size = 45,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final iconThemeColor = iconColor ?? Theme.of(context).colorScheme.accent;
    final textColor = Theme.of(context).colorScheme.accent;

    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.accent,
          side: BorderSide(color: borderColor ?? Theme.of(context).colorScheme.accent, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Square corners
          ),
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconThemeColor,
        ),
      ),
    );
  }
}