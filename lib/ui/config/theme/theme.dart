import 'package:flutter/material.dart';

import 'custom_colors.dart';

class AppTheme {
  static ThemeData lightTheme(Color? primaryColor) => ThemeData(
        colorSchemeSeed: primaryColor,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
        extensions: [
          CustomColors(
            p1: const Color(0xFFAD9307),
            p2: const Color(0xFF565d5a),
            p3: const Color(0xFF764d2c),
            fastestLap: const Color(0xFF6118a6),
          ),
        ],
      );

  static ThemeData darkTheme(Color? primaryColor) => ThemeData(
        colorSchemeSeed: primaryColor,
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
        extensions: [
          CustomColors(
            p1: const Color(0xFFFFE629),
            p2: const Color(0xFFB9C4bE),
            p3: const Color(0xFFc4a482),
            fastestLap: const Color(0xFFc26eff),
          ),
        ],
      );
}
