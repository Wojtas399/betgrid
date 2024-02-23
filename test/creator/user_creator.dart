import 'package:betgrid/model/user.dart';

User createUser({
  String id = '',
  String username = '',
  String? avatarUrl,
  ThemeMode themeMode = ThemeMode.light,
  ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed,
}) =>
    User(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      themeMode: themeMode,
      themePrimaryColor: themePrimaryColor,
    );
