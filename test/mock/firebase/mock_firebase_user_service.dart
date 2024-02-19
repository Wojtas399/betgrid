import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_user_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseUserService extends Mock implements FirebaseUserService {
  MockFirebaseUserService() {
    registerFallbackValue(ThemeModeDto.light);
    registerFallbackValue(ThemePrimaryColorDto.defaultRed);
  }

  void mockLoadUserById({UserDto? userDto}) {
    when(
      () => loadUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(userDto));
  }

  void mockAddUser({UserDto? addedUserDto}) {
    when(
      () => addUser(
        userId: any(named: 'userId'),
        username: any(named: 'username'),
        themeMode: any(named: 'themeMode'),
        themePrimaryColor: any(named: 'themePrimaryColor'),
      ),
    ).thenAnswer((_) => Future.value(addedUserDto));
  }
}
