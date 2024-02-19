import 'package:flutter/material.dart';

import '../../model/user.dart' as user;

extension ThemeModeExtensions on user.ThemeMode {
  ThemeMode get toMaterialThemeMode => switch (this) {
        user.ThemeMode.light => ThemeMode.light,
        user.ThemeMode.dark => ThemeMode.dark,
        user.ThemeMode.system => ThemeMode.system,
      };
}
