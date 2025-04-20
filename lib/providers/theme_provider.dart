// lib/providers/theme_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple state provider for theme
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// Controller notifier for theme
class ThemeNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ThemeNotifier(this._ref) : super(const AsyncValue.data(null));

  // Toggle theme
  void toggleTheme() {
    final currentMode = _ref.read(isDarkModeProvider);
    _ref.read(isDarkModeProvider.notifier).state = !currentMode;
  }
}

// Provider for the theme notifier
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AsyncValue<void>>((ref) {
  return ThemeNotifier(ref);
});
