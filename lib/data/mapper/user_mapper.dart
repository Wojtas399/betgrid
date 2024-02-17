import '../../firebase/model/user_dto/user_dto.dart';
import '../../model/user.dart';

User mapUserFromDto(UserDto userDto, String? avatarUrl) => User(
      id: userDto.id,
      nick: userDto.nick,
      avatarUrl: avatarUrl,
    );