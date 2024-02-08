import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {
  void mockSignInWithGoogle(User? user) {
    when(signInWithGoogle).thenAnswer((_) => Future.value(user));
  }
}
