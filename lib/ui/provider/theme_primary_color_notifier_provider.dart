import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/user.dart';

part 'theme_primary_color_notifier_provider.g.dart';

@riverpod
class ThemePrimaryColorNotifier extends _$ThemePrimaryColorNotifier {
  @override
  ThemePrimaryColor build() {
    return ThemePrimaryColor.defaultRed;
  }

  void changeThemePrimaryColor(ThemePrimaryColor color) {
    state = color;
  }
}
