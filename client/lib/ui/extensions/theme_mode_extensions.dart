import 'package:flutter/material.dart' as material;

import '../../model/user.dart';
import 'build_context_extensions.dart';

extension ThemeModeExtensions on ThemeMode {
  material.ThemeMode get toMaterialThemeMode => switch (this) {
    ThemeMode.light => material.ThemeMode.light,
    ThemeMode.dark => material.ThemeMode.dark,
    ThemeMode.system => material.ThemeMode.system,
  };

  String toThemeModeName(material.BuildContext context) => switch (this) {
    ThemeMode.light => context.str.lightTheme,
    ThemeMode.dark => context.str.darkTheme,
    ThemeMode.system => context.str.systemTheme,
  };
}
