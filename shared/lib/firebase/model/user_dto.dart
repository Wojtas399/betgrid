class UserDto {
  final String id;
  final String username;
  final ThemeModeDto themeMode;
  final ThemePrimaryColorDto themePrimaryColor;

  const UserDto({
    this.id = '',
    required this.username,
    required this.themeMode,
    required this.themePrimaryColor,
  });

  factory UserDto.fromFirestore({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return UserDto(
      id: id,
      username: json[UserFields.username],
      themeMode: _mapThemeModeFromString(json[UserFields.themeMode]),
      themePrimaryColor: _mapThemePrimaryColorFromString(
        json[UserFields.themePrimaryColor],
      ),
    );
  }

  Map<String, dynamic> toFirestore() => {
        UserFields.username: username,
        UserFields.themeMode: themeMode.name,
        UserFields.themePrimaryColor: themePrimaryColor.name,
      };

  static ThemeModeDto _mapThemeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeModeDto.light;
      case 'dark':
        return ThemeModeDto.dark;
      case 'system':
        return ThemeModeDto.system;
      default:
        throw ArgumentError('Invalid theme mode: $value');
    }
  }

  static ThemePrimaryColorDto _mapThemePrimaryColorFromString(String value) {
    switch (value) {
      case 'red':
        return ThemePrimaryColorDto.red;
      case 'pink':
        return ThemePrimaryColorDto.pink;
      case 'purple':
        return ThemePrimaryColorDto.purple;
      case 'brown':
        return ThemePrimaryColorDto.brown;
      case 'orange':
        return ThemePrimaryColorDto.orange;
      case 'yellow':
        return ThemePrimaryColorDto.yellow;
      case 'green':
        return ThemePrimaryColorDto.green;
      case 'blue':
        return ThemePrimaryColorDto.blue;
      default:
        throw ArgumentError('Invalid theme primary color: $value');
    }
  }
}

enum ThemeModeDto { light, dark, system }

enum ThemePrimaryColorDto {
  red,
  pink,
  purple,
  brown,
  orange,
  yellow,
  green,
  blue,
}

class UserFields {
  static const String username = 'username';
  static const String themeMode = 'themeMode';
  static const String themePrimaryColor = 'themePrimaryColor';
}
