import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../config/theme/custom_colors.dart';

extension BuildContextExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Str get str => Str.of(this);

  CustomColors? get customColors => Theme.of(this).extension<CustomColors>();
}
