import 'package:betgrid/firebase/model/user_dto/user_dto.dart';

UserDto createUserDto({
  String id = '',
  String nick = '',
  ThemeModeDto themeMode = ThemeModeDto.light,
}) =>
    UserDto(
      id: id,
      nick: nick,
      themeMode: themeMode,
    );
