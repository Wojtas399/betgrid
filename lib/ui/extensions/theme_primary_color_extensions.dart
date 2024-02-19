import 'package:flutter/material.dart';

import '../../model/user.dart';

extension ThemePrimaryColorExtensions on ThemePrimaryColor {
  Color get toMaterialColor => switch (this) {
        ThemePrimaryColor.defaultRed => Colors.red,
        ThemePrimaryColor.pink => Colors.pink,
        ThemePrimaryColor.purple => Colors.purple,
        ThemePrimaryColor.orange => Colors.orange,
        ThemePrimaryColor.yellow => Colors.yellow,
        ThemePrimaryColor.green => Colors.green,
        ThemePrimaryColor.teal => Colors.teal,
        ThemePrimaryColor.blue => Colors.blue,
      };
}
