
import 'package:flutter/material.dart';

extension CustomColors on ColorScheme {
  Color get quaternary => brightness == Brightness.light
      ? const Color(0xFFF5F5F5)  // Light grey for light theme
      : const Color(0xFF1E1E1E); // Dark grey for dark theme

  Color get quinary => brightness == Brightness.light
      ? const Color(0xFFEEEEEE)  // Lighter grey for light theme
      : Colors.grey.shade900;    // Dark grey for dark theme

  Color get senary => brightness == Brightness.light
      ? const Color(0xFFE0E0E0)  // Even lighter grey for light theme
      : Colors.grey.shade800;    // Medium-dark grey for dark theme

  Color get septenary => brightness == Brightness.light
      ? const Color(0xFFBDBDBD)  // Medium grey for light theme
      : Colors.grey.shade700;    // Medium grey for dark theme

  Color get octonary => brightness == Brightness.light
      ? const Color(0xFF757575)  // Darker grey for light theme
      : Colors.grey.shade300;    // Light grey for dark theme

  Color get nonary => Colors.transparent; // Transparent for both themes

  Color get denary => brightness == Brightness.light
      ? const Color(0xFF212121)  // Almost black for light theme
      : Colors.white;            // White for dark theme
}