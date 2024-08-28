// lib/core/widgets/theme_toggle.dart

import 'package:anecdotal/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Switch(
      value: themeMode == ThemeMode.dark,
      onChanged: (_) {
        ref.read(themeProvider.notifier).toggleTheme();
      },
      activeColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
