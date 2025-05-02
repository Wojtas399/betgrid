import '../../../model/auth_state.dart';

abstract interface class AuthRepository {
  Stream<AuthState> get authState$;

  Stream<String?> get loggedUserId$;

  Future<void> signInWithGoogle();

  Future<void> signOut();
}
