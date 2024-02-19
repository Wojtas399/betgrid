import 'package:flutter/material.dart';

class AppTheme {
  static Color get _seedColor => const Color(0xFFD13317);

  static ThemeData get lightThemeDefault => ThemeData(
        colorSchemeSeed: _seedColor,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _seedColor,
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(color: _seedColor),
        inputDecorationTheme: const InputDecorationTheme(filled: true),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.contains(MaterialState.selected) ? _seedColor : null,
          ),
        ),
      );

  static ThemeData get darkThemeDefault => ThemeData(
        colorSchemeSeed: _seedColor,
        brightness: Brightness.dark,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _seedColor,
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(color: _seedColor),
        inputDecorationTheme: const InputDecorationTheme(filled: true),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.contains(MaterialState.selected) ? _seedColor : null,
          ),
        ),
      );

  static ThemeData lightTheme(Color primaryColor) => ThemeData(
        colorSchemeSeed: primaryColor,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      );

  static ThemeData darkTheme(Color primaryColor) => ThemeData(
        colorSchemeSeed: primaryColor,
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      );
}
