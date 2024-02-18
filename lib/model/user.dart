import 'entity.dart';

class User extends Entity {
  final String nick;
  final String? avatarUrl;
  final ThemeMode themeMode;

  const User({
    required super.id,
    required this.nick,
    this.avatarUrl,
    required this.themeMode,
  });

  @override
  List<Object?> get props => [id, nick, avatarUrl, themeMode];
}

enum ThemeMode { light, dark, system }
