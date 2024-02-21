import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'build_context_extensions.dart';

extension ThemePrimaryColorExtensions on ThemePrimaryColor {
  Color get toMaterialColor => switch (this) {
        ThemePrimaryColor.defaultRed => Colors.red,
        ThemePrimaryColor.pink => Colors.pink,
        ThemePrimaryColor.purple => Colors.purple,
        ThemePrimaryColor.brown => Colors.brown,
        ThemePrimaryColor.orange => Colors.orange,
        ThemePrimaryColor.yellow => Colors.yellow,
        ThemePrimaryColor.green => Colors.green,
        ThemePrimaryColor.blue => Colors.blue,
      };

  String toThemePrimaryColorName(BuildContext context) => switch (this) {
        ThemePrimaryColor.defaultRed => context.str.red,
        ThemePrimaryColor.pink => context.str.pink,
        ThemePrimaryColor.purple => context.str.purple,
        ThemePrimaryColor.brown => context.str.brown,
        ThemePrimaryColor.orange => context.str.orange,
        ThemePrimaryColor.yellow => context.str.yellow,
        ThemePrimaryColor.green => context.str.green,
        ThemePrimaryColor.blue => context.str.blue,
      };
}
