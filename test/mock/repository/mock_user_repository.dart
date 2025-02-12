import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {
  MockUserRepository() {
    registerFallbackValue(ThemeMode.light);
    registerFallbackValue(ThemePrimaryColor.defaultRed);
  }

  void mockGetById({User? user}) {
    when(
      () => getById(any()),
    ).thenAnswer((_) => Stream.value(user));
  }

  void mockAdd({Object? throwable}) {
    if (throwable != null) {
      when(_addCall).thenThrow(throwable);
    } else {
      when(_addCall).thenAnswer((_) => Future.value());
    }
  }

  void mockUpdateData({Object? throwable}) {
    if (throwable != null) {
      when(_updateDataCall).thenThrow(throwable);
    } else {
      when(_updateDataCall).thenAnswer((_) => Future.value());
    }
  }

  void mockUpdateAvatar() {
    when(
      () => updateAvatar(
        userId: any(named: 'userId'),
        avatarImgPath: any(named: 'avatarImgPath'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  Future<void> _addCall() => add(
        userId: any(named: 'userId'),
        username: any(named: 'username'),
        avatarImgPath: any(named: 'avatarImgPath'),
        themeMode: any(named: 'themeMode'),
        themePrimaryColor: any(named: 'themePrimaryColor'),
      );

  Future<void> _updateDataCall() => updateData(
        userId: any(named: 'userId'),
        username: any(named: 'username'),
        themeMode: any(named: 'themeMode'),
        themePrimaryColor: any(named: 'themePrimaryColor'),
      );
}
