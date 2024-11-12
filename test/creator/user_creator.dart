import 'package:betgrid/data/firebase/model/user_dto.dart';
import 'package:betgrid/model/user.dart';

class UserCreator {
  final String id;
  final String username;
  final String? avatarUrl;
  final UserCreatorThemeMode themeMode;
  final UserCreatorThemePrimaryColor themePrimaryColor;

  const UserCreator({
    this.id = '',
    this.username = '',
    this.avatarUrl,
    this.themeMode = UserCreatorThemeMode.light,
    this.themePrimaryColor = UserCreatorThemePrimaryColor.red,
  });

  User createEntity() {
    return User(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      themeMode: _entityThemeMode,
      themePrimaryColor: _entityThemePrimaryColor,
    );
  }

  UserDto createDto() {
    return UserDto(
      id: id,
      username: username,
      themeMode: _dtoThemeMode,
      themePrimaryColor: _dtoThemePrimaryColor,
    );
  }

  Map<String, Object?> createJson() {
    return {
      'username': username,
      'themeMode': themeMode.name,
      'themePrimaryColor': themePrimaryColor.name,
    };
  }

  ThemeMode get _entityThemeMode => switch (themeMode) {
        UserCreatorThemeMode.light => ThemeMode.light,
        UserCreatorThemeMode.dark => ThemeMode.dark,
        UserCreatorThemeMode.system => ThemeMode.system,
      };

  ThemePrimaryColor get _entityThemePrimaryColor => switch (themePrimaryColor) {
        UserCreatorThemePrimaryColor.red => ThemePrimaryColor.defaultRed,
        UserCreatorThemePrimaryColor.pink => ThemePrimaryColor.pink,
        UserCreatorThemePrimaryColor.purple => ThemePrimaryColor.purple,
        UserCreatorThemePrimaryColor.brown => ThemePrimaryColor.brown,
        UserCreatorThemePrimaryColor.orange => ThemePrimaryColor.orange,
        UserCreatorThemePrimaryColor.yellow => ThemePrimaryColor.yellow,
        UserCreatorThemePrimaryColor.green => ThemePrimaryColor.green,
        UserCreatorThemePrimaryColor.blue => ThemePrimaryColor.blue,
      };

  ThemeModeDto get _dtoThemeMode => switch (themeMode) {
        UserCreatorThemeMode.light => ThemeModeDto.light,
        UserCreatorThemeMode.dark => ThemeModeDto.dark,
        UserCreatorThemeMode.system => ThemeModeDto.system,
      };

  ThemePrimaryColorDto get _dtoThemePrimaryColor => switch (themePrimaryColor) {
        UserCreatorThemePrimaryColor.red => ThemePrimaryColorDto.defaultRed,
        UserCreatorThemePrimaryColor.pink => ThemePrimaryColorDto.pink,
        UserCreatorThemePrimaryColor.purple => ThemePrimaryColorDto.purple,
        UserCreatorThemePrimaryColor.brown => ThemePrimaryColorDto.brown,
        UserCreatorThemePrimaryColor.orange => ThemePrimaryColorDto.orange,
        UserCreatorThemePrimaryColor.yellow => ThemePrimaryColorDto.yellow,
        UserCreatorThemePrimaryColor.green => ThemePrimaryColorDto.green,
        UserCreatorThemePrimaryColor.blue => ThemePrimaryColorDto.blue,
      };
}

enum UserCreatorThemeMode { light, dark, system }

enum UserCreatorThemePrimaryColor {
  red,
  pink,
  purple,
  brown,
  orange,
  yellow,
  green,
  blue,
}
