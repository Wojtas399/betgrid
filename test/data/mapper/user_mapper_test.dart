import 'package:betgrid/data/firebase/model/user_dto.dart';
import 'package:betgrid/data/mapper/user_mapper.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock/data/mapper/mock_theme_mode_mapper.dart';
import '../../mock/data/mapper/mock_theme_primary_color_mapper.dart';

void main() {
  final themeModeMapper = MockThemeModeMapper();
  final themePrimaryColorMapper = MockThemePrimaryColorMapper();
  final mapper = UserMapper(themeModeMapper, themePrimaryColorMapper);

  test(
    'mapFromDto, '
    'should map user from UserDto model to User model',
    () {
      const String id = 'u1';
      const String username = 'username';
      const String avatarUrl = 'avatar/url';
      const ThemeMode themeMode = ThemeMode.system;
      const ThemeModeDto themeModeDto = ThemeModeDto.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.blue;
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.blue;
      const UserDto userDto = UserDto(
        id: id,
        username: username,
        themeMode: themeModeDto,
        themePrimaryColor: themePrimaryColorDto,
      );
      const User expectedUser = User(
        id: id,
        username: username,
        avatarUrl: avatarUrl,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      themeModeMapper.mockMapFromDto(
        expectedThemeMode: themeMode,
      );
      themePrimaryColorMapper.mockMapFromDto(
        expectedThemePrimaryColor: themePrimaryColor,
      );

      final User user = mapper.mapFromDto(
        userDto: userDto,
        avatarUrl: avatarUrl,
      );

      expect(user, expectedUser);
    },
  );
}
