import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(Color? primaryColor) => ThemeData(
        colorSchemeSeed: primaryColor,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      );

  static ThemeData darkTheme(Color? primaryColor) => ThemeData(
        colorSchemeSeed: primaryColor,
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      );
}
