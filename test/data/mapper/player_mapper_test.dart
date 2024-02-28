import 'package:betgrid/data/mapper/player_mapper.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/model/player.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/user_dto_creator.dart';

void main() {
  test(
    'mapPlayerFromUserDto, '
    'should map UserDto model to Player model',
    () {
      const String id = 'u1';
      const String username = 'username';
      const String avatarUrl = 'avatar/url';
      final UserDto userDto = createUserDto(
        id: id,
        username: username,
      );
      const Player expectedPlayer = Player(
        id: id,
        username: username,
        avatarUrl: avatarUrl,
      );

      final Player player = mapPlayerFromUserDto(userDto, avatarUrl);

      expect(player, expectedPlayer);
    },
  );
}
