import 'package:flutter/material.dart';

class AppTheme {
  static Color get _seedColor => Colors.red;

  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
    useMaterial3: true,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}