import 'package:flutter/material.dart';

class AppTheme {
  static Color get _seedColor => Colors.red;

  static ThemeData get lightTheme => ThemeData(
        colorSchemeSeed: _seedColor,
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        colorSchemeSeed: _seedColor,
        useMaterial3: true,
        brightness: Brightness.dark,
      );
}
