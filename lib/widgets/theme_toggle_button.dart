import 'package:anecdotal/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Switch(
      value: isDarkMode,
      onChanged: (_) {
        ref.read(themeProvider.notifier).toggleTheme();
      },
      activeColor: Theme.of(context).colorScheme.secondary,
      inactiveThumbColor: Theme.of(context).colorScheme.primary,
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.dark_mode);
          }
          return const Icon(Icons.light_mode);
        },
      ),
    );
  }
}
