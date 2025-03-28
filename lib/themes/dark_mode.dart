import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*extension CustomColors on ColorScheme {
  Color get quaternary => const Color(0xFF1E1E1E);     // Dark background used in cards
  Color get quinary => Colors.grey.shade900;           // Card background in ShopProductCard
  Color get senary => Colors.grey.shade800;            // Loading background
  Color get septenary => Colors.grey.shade700;         // Border color for tags
  Color get octonary => Colors.grey.shade300;          // Text color in ShopProductCard
  Color get nonary => Colors.transparent;              // Transparent background
  Color get denary => Colors.white;                    // White text
}*/

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,

  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.black,

  ),

  /*textTheme: TextTheme(
    displayLarge: GoogleFonts.dmSerifDisplay(fontSize: 32, fontWeight: FontWeight.bold), // Replaces headline1
    titleLarge: GoogleFonts.dmSerifDisplay(fontSize: 24, fontWeight: FontWeight.w600), // Replaces headline6
    bodyLarge: GoogleFonts.dmSerifDisplay(fontSize: 16),
    bodyMedium: GoogleFonts.dmSerifDisplay(fontSize: 14),
    bodySmall: GoogleFonts.dmSerifDisplay(fontSize: 12),
  )
);*/

  textTheme: TextTheme(
    // Large titles
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
    ),

    // Section headers
    titleLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),

    // Smaller headers
    titleMedium: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    ),

    // Regular body text
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      letterSpacing: 0.5,
    ),

    // Smaller body text
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      letterSpacing: 0.5,
    ),

    // Small labels
    bodySmall: GoogleFonts.montserrat(
      fontSize: 12,
      letterSpacing: 0.5,
    ),
  ),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      textStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    ),
  ),

  // Outlined button theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      textStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    ),
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade900,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.grey.shade800),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.grey.shade800),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(color: Colors.white),
    ),
    hintStyle: TextStyle(color: Colors.grey.shade600),
  ),

  // Chip theme
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade800,
    selectedColor: Colors.white,
    disabledColor: Colors.grey.shade900,
    labelStyle: GoogleFonts.montserrat(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    secondaryLabelStyle: GoogleFonts.montserrat(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  ),

  // Card theme
  cardTheme: CardTheme(
    color: Colors.grey.shade900,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  ),
);