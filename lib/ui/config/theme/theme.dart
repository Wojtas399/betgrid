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
        win: const Color(0xFF48AB50),
        loss: const Color(0xFFD91A20),
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
        p3: const Color(0xFFC4A482),
        fastestLap: const Color(0xFFC26Eff),
        win: const Color(0xFF63D169),
        loss: const Color(0xFFDC2828),
      ),
    ],
  );
}
