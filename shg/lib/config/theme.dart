import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF00897B);
  static const Color lightGreen = Color(0xFFB2DFDB);
  static const Color lightOrange = Color(0xFFFFCC80);
  static const Color lightBlue = Color(0xFF90CAF9);
  static const Color lightPurple = Color(0xFFCE93D8);
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      primaryColor: const Color(0xFF00897B),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF00897B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00897B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
