import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_user_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseUserService extends Mock implements FirebaseUserService {
  MockFirebaseUserService() {
    registerFallbackValue(ThemeModeDto.light);
    registerFallbackValue(ThemePrimaryColorDto.defaultRed);
  }

  void mockFetchUserById({UserDto? userDto}) {
    when(
      () => fetchUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(userDto));
  }

  void mockFetchAllUsers({required List<UserDto> userDtos}) {
    when(fetchAllUsers).thenAnswer((_) => Future.value(userDtos));
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

  void mockUpdateUser({UserDto? updatedUserDto}) {
    when(
      () => updateUser(
        userId: any(named: 'userId'),
        username: any(named: 'username'),
        themeMode: any(named: 'themeMode'),
        themePrimaryColor: any(named: 'themePrimaryColor'),
      ),
    ).thenAnswer((_) => Future.value(updatedUserDto));
  }

  void mockIsUsernameAlreadyTaken({required bool isAlreadyTaken}) {
    when(
      () => isUsernameAlreadyTaken(
        username: any(
          named: 'username',
        ),
      ),
    ).thenAnswer((invocation) => Future.value(isAlreadyTaken));
  }
}
