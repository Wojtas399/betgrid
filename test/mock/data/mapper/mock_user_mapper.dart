import 'package:betgrid/data/mapper/user_mapper.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_creator.dart';

class MockUserMapper extends Mock implements UserMapper {
  MockUserMapper() {
    registerFallbackValue(
      const UserCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required User expectedUser,
  }) {
    when(
      () => mapFromDto(
        userDto: any(named: 'userDto'),
        avatarUrl: any(named: 'avatarUrl'),
      ),
    ).thenReturn(expectedUser);
  }
}
