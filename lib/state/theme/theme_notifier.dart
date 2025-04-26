import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme state class
class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

// Theme notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(isDarkMode: false)) {
    _loadThemePreference();
  }

  // Load saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    state = ThemeState(isDarkMode: isDarkMode);
  }

  // Save theme preference
  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Toggle between light and dark theme
  void toggleTheme() {
    final newIsDarkMode = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newIsDarkMode);
    _saveThemePreference(newIsDarkMode);
  }

  // Set specific theme
  void setDarkMode(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
    _saveThemePreference(isDarkMode);
  }
}