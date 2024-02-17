import 'package:flutter/material.dart';

class AppTheme {
  static Color get _seedColor => const Color(0xFFD13317);

  static Color get _lightBackgroundColor => const Color(0xFFf7f8fa);

  static Color get _darkBackgroundColor => const Color(0xFF242526);

  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.light(primary: _seedColor),
        scaffoldBackgroundColor: _lightBackgroundColor,
        appBarTheme: AppBarTheme(backgroundColor: _lightBackgroundColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _seedColor,
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(color: _seedColor),
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.dark(primary: _seedColor),
        scaffoldBackgroundColor: _darkBackgroundColor,
        appBarTheme: AppBarTheme(backgroundColor: _darkBackgroundColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _seedColor,
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(color: _seedColor),
      );
}
