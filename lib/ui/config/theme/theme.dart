import 'package:flutter/material.dart';

class AppTheme {
  static Color get _seedColor => const Color(0xFFD13317);

  static ThemeData get lightTheme => ThemeData(
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

  static ThemeData get darkTheme => ThemeData(
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
}
