import 'package:betgrid/firebase/service/firebase_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
  void mockGetLoggedUserId(String? loggedUserId) {
    when(() => loggedUserId$).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockSignInWithGoogle(String? userId) {
    when(signInWithGoogle).thenAnswer((_) => Future.value());
  }
}
