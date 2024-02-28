import '../../firebase/model/user_dto/user_dto.dart';
import '../../model/player.dart';

Player mapPlayerFromUserDto(UserDto userDto, String? avatarUrl) => Player(
      id: userDto.id,
      username: userDto.username,
      avatarUrl: avatarUrl,
    );
