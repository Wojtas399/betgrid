import 'package:betgrid/data/firebase/model/user_dto/user_dto.dart';

UserDto createUserDto({
  String id = '',
  String username = '',
  ThemeModeDto themeMode = ThemeModeDto.light,
  ThemePrimaryColorDto themePrimaryColor = ThemePrimaryColorDto.defaultRed,
}) =>
    UserDto(
      id: id,
      username: username,
      themeMode: themeMode,
      themePrimaryColor: themePrimaryColor,
    );
