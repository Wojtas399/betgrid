import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? p1;
  final Color? p2;
  final Color? p3;
  final Color? fastestLap;

  CustomColors({
    required this.p1,
    required this.p2,
    required this.p3,
    required this.fastestLap,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? p1,
    Color? p2,
    Color? p3,
    Color? fastestLap,
  }) =>
      CustomColors(
        p1: p1 ?? this.p1,
        p2: p2 ?? this.p2,
        p3: p3 ?? this.p3,
        fastestLap: fastestLap ?? this.fastestLap,
      );

  @override
  ThemeExtension<CustomColors> lerp(
    CustomColors? other,
    double t,
  ) =>
      other is! CustomColors
          ? this
          : CustomColors(
              p1: Color.lerp(p1, other.p1, t),
              p2: Color.lerp(p2, other.p2, t),
              p3: Color.lerp(p3, other.p3, t),
              fastestLap: Color.lerp(fastestLap, other.fastestLap, t),
            );
}
