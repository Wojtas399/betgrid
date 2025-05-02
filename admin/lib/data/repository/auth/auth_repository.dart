import '../../../model/auth_state.dart';

abstract interface class AuthRepository {
  Stream<AuthState> get authState$;

  Future<void> signInWithGoogle();
}
