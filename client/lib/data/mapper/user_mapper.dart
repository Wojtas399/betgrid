import 'package:betgrid_shared/firebase/model/user_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/user.dart';
import 'theme_mode_mapper.dart';
import 'theme_primary_color_mapper.dart';

@injectable
class UserMapper {
  final ThemeModeMapper _themeModeMapper;
  final ThemePrimaryColorMapper _themePrimaryColorMapper;

  const UserMapper(this._themeModeMapper, this._themePrimaryColorMapper);

  User mapFromDto({required UserDto userDto, String? avatarUrl}) => User(
    id: userDto.id,
    username: userDto.username,
    avatarUrl: avatarUrl,
    themeMode: _themeModeMapper.mapFromDto(userDto.themeMode),
    themePrimaryColor: _themePrimaryColorMapper.mapFromDto(
      userDto.themePrimaryColor,
    ),
  );
}
