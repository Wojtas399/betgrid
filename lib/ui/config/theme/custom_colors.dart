import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? p1;
  final Color? p2;
  final Color? p3;
  final Color? fastestLap;
  final Color? win;
  final Color? loss;

  CustomColors({
    required this.p1,
    required this.p2,
    required this.p3,
    required this.fastestLap,
    required this.win,
    required this.loss,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? p1,
    Color? p2,
    Color? p3,
    Color? fastestLap,
    Color? win,
    Color? loss,
  }) =>
      CustomColors(
        p1: p1 ?? this.p1,
        p2: p2 ?? this.p2,
        p3: p3 ?? this.p3,
        fastestLap: fastestLap ?? this.fastestLap,
        win: win ?? this.win,
        loss: loss ?? this.loss,
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
              win: Color.lerp(win, other.win, t),
              loss: Color.lerp(loss, other.loss, t),
            );
}
