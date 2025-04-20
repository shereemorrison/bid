

import 'package:bid/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef
  ref) {
    final isDarkMode = ref.watch
      (isDarkModeProvider);

    return IconButton(
      icon: Icon(
        isDarkMode
            ? Icons.light_mode
            : Icons.dark_mode,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        ref.read(themeNotifierProvider.notifier).toggleTheme();
      },
    );
  }
}