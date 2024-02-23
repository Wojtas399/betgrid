import 'package:betgrid/data/mapper/theme_mode_mapper.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'mapThemeModeFromDto, '
    'ThemeModeDto.light should be mapped to ThemeMode.light',
    () {
      const ThemeModeDto themeModeDto = ThemeModeDto.light;
      const ThemeMode expectedThemeMode = ThemeMode.light;

      final ThemeMode themeMode = mapThemeModeFromDto(themeModeDto);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'mapThemeModeFromDto, '
    'ThemeModeDto.dark should be mapped to ThemeMode.dark',
    () {
      const ThemeModeDto themeModeDto = ThemeModeDto.dark;
      const ThemeMode expectedThemeMode = ThemeMode.dark;

      final ThemeMode themeMode = mapThemeModeFromDto(themeModeDto);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'mapThemeModeFromDto, '
    'ThemeModeDto.system should be mapped to ThemeMode.system',
    () {
      const ThemeModeDto themeModeDto = ThemeModeDto.system;
      const ThemeMode expectedThemeMode = ThemeMode.system;

      final ThemeMode themeMode = mapThemeModeFromDto(themeModeDto);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'mapThemeModeToDto, '
    'ThemeMode.light should be mapped to ThemeModeDto.light',
    () {
      const ThemeMode themeMode = ThemeMode.light;
      const ThemeModeDto expectedThemeModeDto = ThemeModeDto.light;

      final ThemeModeDto themeModeDto = mapThemeModeToDto(themeMode);

      expect(themeModeDto, expectedThemeModeDto);
    },
  );

  test(
    'mapThemeModeToDto, '
    'ThemeMode.dark should be mapped to ThemeModeDto.dark',
    () {
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemeModeDto expectedThemeModeDto = ThemeModeDto.dark;

      final ThemeModeDto themeModeDto = mapThemeModeToDto(themeMode);

      expect(themeModeDto, expectedThemeModeDto);
    },
  );

  test(
    'mapThemeModeToDto, '
    'ThemeMode.system should be mapped to ThemeModeDto.system',
    () {
      const ThemeMode themeMode = ThemeMode.system;
      const ThemeModeDto expectedThemeModeDto = ThemeModeDto.system;

      final ThemeModeDto themeModeDto = mapThemeModeToDto(themeMode);

      expect(themeModeDto, expectedThemeModeDto);
    },
  );
}
