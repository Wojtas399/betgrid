import '../../model/user.dart';
import '../firebase/model/user_dto/user_dto.dart';

ThemeMode mapThemeModeFromDto(ThemeModeDto themeModeDto) =>
    switch (themeModeDto) {
      ThemeModeDto.light => ThemeMode.light,
      ThemeModeDto.dark => ThemeMode.dark,
      ThemeModeDto.system => ThemeMode.system,
    };

ThemeModeDto mapThemeModeToDto(ThemeMode themeMode) => switch (themeMode) {
      ThemeMode.light => ThemeModeDto.light,
      ThemeMode.dark => ThemeModeDto.dark,
      ThemeMode.system => ThemeModeDto.system,
    };
