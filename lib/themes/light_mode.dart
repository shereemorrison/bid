import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_colors.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    // Invert the primary colors
    surface: Colors.white,
    primary: Colors.grey,
    secondary: const Color(0xFFb8b0a4),
    inversePrimary: Colors.grey.shade100,
  ),

  // Keep the same font styles
  textTheme: TextTheme(
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
);