import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  void mockGetLoggedUserId(String? loggedUserId) {
    when(() => loggedUserId$).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockSignInWithGoogle(String? userId) {
    when(signInWithGoogle).thenAnswer((_) => Future.value(userId));
  }
}
