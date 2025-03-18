import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension CustomColors on ColorScheme {
  Color get quaternary => const Color(0xFF1E1E1E);     // Dark background used in cards
  Color get quinary => Colors.grey.shade900;           // Card background in ShopProductCard
  Color get senary => Colors.grey.shade800;            // Loading background
  Color get septenary => Colors.grey.shade700;         // Border color for tags
  Color get octonary => Colors.grey.shade300;          // Text color in ShopProductCard
  Color get nonary => Colors.transparent;              // Transparent background
  Color get denary => Colors.white;                    // White text
}

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.white,
    secondary: Color(0xFFb8b0a4),
    inversePrimary: Colors.grey.shade400,

  ),

  textTheme: TextTheme(
    displayLarge: GoogleFonts.dmSerifDisplay(fontSize: 32, fontWeight: FontWeight.bold), // Replaces headline1
    titleLarge: GoogleFonts.dmSerifDisplay(fontSize: 24, fontWeight: FontWeight.w600), // Replaces headline6
    bodyLarge: GoogleFonts.dmSerifDisplay(fontSize: 16),
    bodyMedium: GoogleFonts.dmSerifDisplay(fontSize: 14),
    bodySmall: GoogleFonts.dmSerifDisplay(fontSize: 12),
  )
);