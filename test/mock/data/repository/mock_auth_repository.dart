import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/model/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  void mockGetAuthState({required AuthState authState}) {
    when(() => authState$).thenAnswer((_) => Stream.value(authState));
  }

  void mockGetLoggedUserId(String? loggedUserId) {
    when(() => loggedUserId$).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockSignInWithGoogle() {
    when(signInWithGoogle).thenAnswer((_) => Future.value());
  }
}
