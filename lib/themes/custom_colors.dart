
import 'package:flutter/material.dart';

extension CustomColors on ColorScheme {

  Color get background => brightness == Brightness.light
      ? Colors.white
      : Colors.black;

  Color get cardBackground => brightness == Brightness.light
      ? Colors.grey.shade50
      : Colors.grey.shade900;

  Color get borderColor => brightness == Brightness.light
      ? Colors.grey.shade300
      : Colors.grey.shade800;

  Color get textPrimary => brightness == Brightness.light
      ? Colors.black
      : Colors.white;

  Color get textSecondary => brightness == Brightness.light
      ? Colors.grey.shade700
      : Colors.grey.shade400;

  Color get accent => brightness == Brightness.light
      ? Colors.black
      : Colors.white;
}