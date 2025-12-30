import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6DBEA2),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F7F6), 
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6DBEA2),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  // Dashboard Color Palette
  static const Color primaryGreen = Color(0xFF6DBEA2);
  static const Color cardGreen = Color(0xFF2E7D32);
  static const Color cardBlue = Color(0xFF1565C0);
  static const Color cardOrange = Color(0xFFD84315);
  static const Color cardPurple = Color(0xFF6A1B9A);
}