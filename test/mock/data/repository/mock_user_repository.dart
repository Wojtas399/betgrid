import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {
  MockUserRepository() {
    registerFallbackValue(ThemeMode.light);
    registerFallbackValue(ThemePrimaryColor.defaultRed);
  }

  void mockGetUserById({User? user}) {
    when(
      () => getUserById(userId: any(named: 'userId')),
    ).thenAnswer((_) => Stream.value(user));
  }

  void mockAddUser({Object? throwable}) {
    if (throwable != null) {
      when(_addUserCall).thenThrow(throwable);
    } else {
      when(_addUserCall).thenAnswer((_) => Future.value());
    }
  }

  void mockUpdateUserData({Object? throwable}) {
    if (throwable != null) {
      when(_updateUserDataCall).thenThrow(throwable);
    } else {
      when(_updateUserDataCall).thenAnswer((_) => Future.value());
    }
  }

  Future<void> _addUserCall() => addUser(
        userId: any(named: 'userId'),
        username: any(named: 'username'),
        avatarImgPath: any(named: 'avatarImgPath'),
        themeMode: any(named: 'themeMode'),
        themePrimaryColor: any(named: 'themePrimaryColor'),
      );

  Future<void> _updateUserDataCall() => updateUserData(
        userId: any(named: 'userId'),
        username: any(named: 'username'),
        themeMode: any(named: 'themeMode'),
        themePrimaryColor: any(named: 'themePrimaryColor'),
      );
}
