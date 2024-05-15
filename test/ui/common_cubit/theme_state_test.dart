import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/common_cubit/theme_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'default state, '
    'theme mode should be set to system, '
    'primary color should be set to defaultRed',
    () {
      const expectedState = ThemeState(
        themeMode: ThemeMode.system,
        primaryColor: ThemePrimaryColor.defaultRed,
      );

      const state = ThemeState();

      expect(state, expectedState);
    },
  );
}
