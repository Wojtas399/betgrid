import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
  void mockGetLoggedUser(UserDto? userDto) {
    when(() => loggedUser$).thenAnswer((_) => Stream.value(userDto));
  }

  void mockSignInWithGoogle(UserDto? userDto) {
    when(signInWithGoogle).thenAnswer((_) => Future.value(userDto));
  }
}
