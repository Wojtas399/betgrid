import 'package:betgrid/data/firebase/model/user_dto.dart';
import 'package:betgrid/data/mapper/player_mapper.dart';
import 'package:betgrid/model/player.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/user_creator.dart';

void main() {
  final mapper = PlayerMapper();

  test(
    'mapFromDto, '
    'should map UserDto model to Player model',
    () {
      const String id = 'u1';
      const String username = 'username';
      const String avatarUrl = 'avatar/url';
      final UserDto userDto = UserCreator(
        id: id,
        username: username,
      ).createDto();
      const Player expectedPlayer = Player(
        id: id,
        username: username,
        avatarUrl: avatarUrl,
      );

      final Player player = mapper.mapFromDto(
        userDto: userDto,
        avatarUrl: avatarUrl,
      );

      expect(player, expectedPlayer);
    },
  );
}
