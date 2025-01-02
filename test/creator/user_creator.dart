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

  User create() {
    return User(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      themeMode: _entityThemeMode,
      themePrimaryColor: _entityThemePrimaryColor,
    );
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
