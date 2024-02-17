import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {
  void mockGetUserById({User? user}) {
    when(
      () => getUserById(userId: any(named: 'userId')),
    ).thenAnswer((_) => Stream.value(user));
  }

  void mockAddUser() {
    when(
      () => addUser(
        userId: any(named: 'userId'),
        nick: any(named: 'nick'),
        avatarImgPath: any(named: 'avatarImgPath'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
