// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4A90E2),  // Soft Blue
        primaryContainer: Color(0xFF5AC8FA),  // Light Teal
        secondary: Color(0xFF8BC34A),  // Light Green
        tertiary: Color(0xFF9C27B0),  // Light Gray
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,  // Dark Gray
        onSurface: Color(0xFF333333),  // Dark Gray
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF333333)),  // Dark Gray
        bodyMedium: TextStyle(color: Color(0xFF333333)),  // Dark Gray
        titleLarge: TextStyle(color: Color(0xFF1A237E)),  // Navy Blue
        titleMedium: TextStyle(color: Color(0xFF1A237E)),  // Navy Blue
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4A90E2),  // Soft Blue
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5AC8FA),  // Light Teal
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF8BC34A),  // Light Green
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF64B5F6),  // Lighter Soft Blue
        primaryContainer: Color(0xFF4FC3F7),  // Lighter Teal
        secondary: Color(0xFFAED581),  // Lighter Green
        tertiary: Color(0xFFE1BEE7),  // Dark Gray
        surface: Color(0xFF1E1E1E),  // Slightly lighter than background
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Color(0xFFBBDEFB)),  // Very Light Blue
        titleMedium: TextStyle(color: Color(0xFFBBDEFB)),  // Very Light Blue
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF2C2C2C),
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4FC3F7),  // Lighter Teal
          foregroundColor: Colors.black,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFAED581),  // Lighter Green
        foregroundColor: Colors.black,
      ),
    );
  }
}