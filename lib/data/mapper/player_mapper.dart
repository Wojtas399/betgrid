import 'package:injectable/injectable.dart';

import '../../model/player.dart';
import '../firebase/model/user_dto.dart';

@injectable
class PlayerMapper {
  Player mapFromDto({
    required UserDto userDto,
    String? avatarUrl,
  }) =>
      Player(
        id: userDto.id,
        username: userDto.username,
        avatarUrl: avatarUrl,
      );
}

Player mapPlayerFromUserDto(UserDto userDto, String? avatarUrl) => Player(
      id: userDto.id,
      username: userDto.username,
      avatarUrl: avatarUrl,
    );
