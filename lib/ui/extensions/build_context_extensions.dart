import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config/theme/custom_colors.dart';

extension BuildContextExtensions on BuildContext {
  Str get str => Str.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  CustomColors? get customColors => Theme.of(this).extension<CustomColors>();
}
