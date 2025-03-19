
import 'package:flutter/material.dart';

extension CustomColors on ColorScheme {
  Color get quaternary => brightness == Brightness.light
      ? Colors.white  // Light grey for light theme
      : const Color(0xFF1E1E1E); // Dark grey for dark theme

  Color get quinary => brightness == Brightness.light
      ? Colors.white  // Lighter grey for light theme
      : Colors.grey.shade900;    // Dark grey for dark theme

  Color get senary => brightness == Brightness.light
      ? Colors.white  // Even lighter grey for light theme
      : Colors.grey.shade800;    // Medium-dark grey for dark theme

  Color get septenary => brightness == Brightness.light
      ? Colors.white  // Medium grey for light theme
      : Colors.grey.shade700;    // Medium grey for dark theme

  Color get octonary => brightness == Brightness.light
      ? Colors.white // Darker grey for light theme
      : Colors.grey.shade300;    // Light grey for dark theme

  Color get nonary => Colors.transparent; // Transparent for both themes

  Color get denary => brightness == Brightness.light
      ? Colors.black // Almost black for light theme
      : Colors.white;            // White for dark theme
}