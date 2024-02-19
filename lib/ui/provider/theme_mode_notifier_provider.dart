import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/user.dart';

part 'theme_mode_notifier_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void changeThemeMode(ThemeMode mode) {
    state = mode;
  }
}
