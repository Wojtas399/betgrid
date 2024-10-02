import 'package:betgrid/data/mapper/player_mapper.dart';
import 'package:betgrid/model/player.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_creator.dart';

class MockPlayerMapper extends Mock implements PlayerMapper {
  MockPlayerMapper() {
    registerFallbackValue(UserCreator().createDto());
  }

  void mockMapFromDto({
    required Player expectedPlayer,
  }) {
    when(
      () => mapFromDto(
        userDto: any(named: 'userDto'),
        avatarUrl: any(named: 'avatarUrl'),
      ),
    ).thenReturn(expectedPlayer);
  }
}
