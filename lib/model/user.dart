import 'entity.dart';

class User extends Entity {
  final String username;
  final String? avatarUrl;
  final ThemeMode themeMode;
  final ThemePrimaryColor themePrimaryColor;

  const User({
    required super.id,
    required this.username,
    this.avatarUrl,
    required this.themeMode,
    required this.themePrimaryColor,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        avatarUrl,
        themeMode,
        themePrimaryColor,
      ];
}

enum ThemeMode { light, dark, system }

enum ThemePrimaryColor {
  defaultRed,
  pink,
  purple,
  brown,
  orange,
  yellow,
  green,
  blue,
}
