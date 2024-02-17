import 'package:betgrid/auth/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {
  void mockGetLoggedUserId(String? loggedUserId) {
    when(() => loggedUserId$).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockSignInWithGoogle(String? userId) {
    when(signInWithGoogle).thenAnswer((_) => Future.value(userId));
  }
}
