import '../../firebase/model/user_dto/user_dto.dart';
import '../../model/user.dart';
import 'theme_mode_mapper.dart';
import 'theme_primary_color_mapper.dart';

User mapUserFromDto(UserDto userDto, String? avatarUrl) => User(
      id: userDto.id,
      username: userDto.username,
      avatarUrl: avatarUrl,
      themeMode: mapThemeModeFromDto(userDto.themeMode),
      themePrimaryColor: mapThemePrimaryColorFromDto(userDto.themePrimaryColor),
    );
