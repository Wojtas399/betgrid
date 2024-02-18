import 'package:betgrid/model/user.dart';

User createUser({
  String id = '',
  String nick = '',
  String? avatarUrl,
  ThemeMode themeMode = ThemeMode.light,
}) =>
    User(
      id: id,
      nick: nick,
      avatarUrl: avatarUrl,
      themeMode: themeMode,
    );
