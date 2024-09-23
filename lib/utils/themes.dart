import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        fontFamily: 'Raleway',
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.teal,
          primaryContainer: Colors.teal[100]!,
          secondary: Colors.tealAccent[700]!,
          tertiary: Colors.teal[300]!,
          surface: Colors.teal[50]!,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.teal[900]!,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.teal[900]),
          bodyMedium: TextStyle(color: Colors.teal[900]),
          titleLarge: const TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.teal[800]),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.teal[80],
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[300],
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent[700],
          foregroundColor: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.teal[600],
          // size: 24.0,
        ),
        tabBarTheme: TabBarTheme());
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Raleway',
      colorScheme: ColorScheme.dark(
        primary: Colors.teal[300]!,
        primaryContainer: Colors.teal[700]!,
        secondary: Colors.tealAccent[400]!,
        tertiary: Colors.teal[200]!,
        surface: Colors.grey[900]!,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(color: Colors.white),
        bodyMedium: const TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.teal[100]),
        titleMedium: TextStyle(color: Colors.teal[100]),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardTheme(
        color: Colors.black45,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.white,
          iconColor: Colors.teal[200],
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.tealAccent[400],
        foregroundColor: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.teal[200],
        // size: 24.0,
      ),
    );
  }
}
