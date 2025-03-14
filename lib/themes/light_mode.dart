import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.black,
    primary: Colors.white,
    secondary: Color(0xFFb8b0a4),
    inversePrimary: Colors.grey.shade300,
  ),

  textTheme: TextTheme(
    displayLarge: GoogleFonts.dmSerifDisplay(fontSize: 32, fontWeight: FontWeight.bold), // Replaces headline1
    titleLarge: GoogleFonts.dmSerifDisplay(fontSize: 24, fontWeight: FontWeight.w600), // Replaces headline6
    bodyLarge: GoogleFonts.dmSerifDisplay(fontSize: 16),
    bodyMedium: GoogleFonts.dmSerifDisplay(fontSize: 14),
    bodySmall: GoogleFonts.dmSerifDisplay(fontSize: 12),
  )
);