import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {
  void mockGetLoggedUserId(String? loggedUserId) {
    when(() => loggedUserId$).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockSignInWithGoogle(User? user) {
    when(signInWithGoogle).thenAnswer((_) => Future.value(user));
  }
}
