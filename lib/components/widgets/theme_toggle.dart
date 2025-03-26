// lib/widgets/theme_toggle.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        context.watch<ThemeProvider>().isDarkMode
            ? Icons.light_mode
            : Icons.dark_mode,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        // Print before and after to debug
        print('Before toggle: ${context.read<ThemeProvider>().isDarkMode}');
        context.read<ThemeProvider>().toggleTheme();
        print('After toggle: ${context.read<ThemeProvider>().isDarkMode}');
      },
    );
  }
}