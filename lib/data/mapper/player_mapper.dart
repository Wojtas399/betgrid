import 'package:betgrid_shared/firebase/model/user_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/player.dart';

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

Player mapPlayerFromUserDto(
  UserDto userDto,
  String? avatarUrl,
) =>
    Player(
      id: userDto.id,
      username: userDto.username,
      avatarUrl: avatarUrl,
    );
