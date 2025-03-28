import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,

  colorScheme: ColorScheme.light(
    // Invert the primary colors
    surface: Colors.white,
    primary: Colors.black,
    secondary: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),

  // Keep the same font styles
  /*textTheme: TextTheme(
    displayLarge: GoogleFonts.dmSerifDisplay(fontSize: 32, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.dmSerifDisplay(fontSize: 24, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.dmSerifDisplay(fontSize: 16),
    bodyMedium: GoogleFonts.dmSerifDisplay(fontSize: 14),
    bodySmall: GoogleFonts.dmSerifDisplay(fontSize: 12),
  ),
  // Customize component themes
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
);*/

  textTheme: TextTheme(
    // Large titles
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      color: Colors.black,
    ),

    // Section headers
    titleLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
      color: Colors.black,
    ),

    // Smaller headers
    titleMedium: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
      color: Colors.black,
    ),

    // Regular body text
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      letterSpacing: 0.5,
      color: Colors.black,
    ),

    // Smaller body text
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      letterSpacing: 0.5,
      color: Colors.black,
    ),

    // Small labels
    bodySmall: GoogleFonts.montserrat(
      fontSize: 12,
      letterSpacing: 0.5,
      color: Colors.black,
    ),
  ),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
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
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black),
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
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(color: Colors.black),
    ),
    hintStyle: TextStyle(color: Colors.grey.shade600),
  ),

  // Chip theme
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade200,
    selectedColor: Colors.black,
    disabledColor: Colors.grey.shade100,
    labelStyle: GoogleFonts.montserrat(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    secondaryLabelStyle: GoogleFonts.montserrat(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  ),

  // Card theme
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
      side: BorderSide(color: Colors.grey.shade200),
    ),
  ),
);
