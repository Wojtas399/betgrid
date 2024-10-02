import 'package:betgrid/data/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/data/mapper/theme_mode_mapper.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mapper = ThemeModeMapper();

  test(
    'mapFromDto, '
    'ThemeModeDto.light should be mapped to ThemeMode.light',
    () {
      const ThemeModeDto themeModeDto = ThemeModeDto.light;
      const ThemeMode expectedThemeMode = ThemeMode.light;

      final ThemeMode themeMode = mapper.mapFromDto(themeModeDto);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'mapFromDto, '
    'ThemeModeDto.dark should be mapped to ThemeMode.dark',
    () {
      const ThemeModeDto themeModeDto = ThemeModeDto.dark;
      const ThemeMode expectedThemeMode = ThemeMode.dark;

      final ThemeMode themeMode = mapper.mapFromDto(themeModeDto);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'mapFromDto, '
    'ThemeModeDto.system should be mapped to ThemeMode.system',
    () {
      const ThemeModeDto themeModeDto = ThemeModeDto.system;
      const ThemeMode expectedThemeMode = ThemeMode.system;

      final ThemeMode themeMode = mapper.mapFromDto(themeModeDto);

      expect(themeMode, expectedThemeMode);
    },
  );

  test(
    'mapToDto, '
    'ThemeMode.light should be mapped to ThemeModeDto.light',
    () {
      const ThemeMode themeMode = ThemeMode.light;
      const ThemeModeDto expectedThemeModeDto = ThemeModeDto.light;

      final ThemeModeDto themeModeDto = mapper.mapToDto(themeMode);

      expect(themeModeDto, expectedThemeModeDto);
    },
  );

  test(
    'mapToDto, '
    'ThemeMode.dark should be mapped to ThemeModeDto.dark',
    () {
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemeModeDto expectedThemeModeDto = ThemeModeDto.dark;

      final ThemeModeDto themeModeDto = mapper.mapToDto(themeMode);

      expect(themeModeDto, expectedThemeModeDto);
    },
  );

  test(
    'mapToDto, '
    'ThemeMode.system should be mapped to ThemeModeDto.system',
    () {
      const ThemeMode themeMode = ThemeMode.system;
      const ThemeModeDto expectedThemeModeDto = ThemeModeDto.system;

      final ThemeModeDto themeModeDto = mapper.mapToDto(themeMode);

      expect(themeModeDto, expectedThemeModeDto);
    },
  );
}
