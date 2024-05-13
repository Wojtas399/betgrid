import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/user.dart';

part 'theme_state.freezed.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(ThemePrimaryColor.defaultRed) ThemePrimaryColor primaryColor,
  }) = _ThemeState;
}
