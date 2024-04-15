import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class CustomColors {
  Color get gold => const Color(0xFFFBC00E);

  Color get silver => const Color(0xFF7A8480);

  Color get brown => const Color(0xFFAA6B39);

  Color get violet => const Color(0xFF8B1AF5);
}
