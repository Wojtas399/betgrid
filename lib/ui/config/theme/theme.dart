import 'package:flutter/material.dart';

class AppTheme {
  static Color get _seedColor => const Color(0xFFD13317);

  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.light(primary: _seedColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _seedColor,
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _seedColor,
          foregroundColor: Colors.white,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.dark(
          primary: _seedColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _seedColor,
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _seedColor,
          foregroundColor: Colors.white,
        ),
      );
}
