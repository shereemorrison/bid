import 'package:bid/state/theme/theme_notifier.dart';
import 'package:bid/themes/dark_mode.dart';
import 'package:bid/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeNotifierProvider).isDarkMode;
});

final themeProvider = Provider<ThemeData>((ref) {
  return ref.watch(isDarkModeProvider) ? darkMode : lightMode;
});
