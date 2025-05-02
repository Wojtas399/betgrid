import 'package:betgrid_shared/firebase/service/firebase_auth_service.dart';
import 'package:injectable/injectable.dart';

import '../../../model/auth_state.dart';
import 'auth_repository.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _dbAuthService;

  AuthRepositoryImpl(this._dbAuthService);

  @override
  Stream<AuthState> get authState$ => _dbAuthService.loggedUserId$.map(
    (String? loggedUserId) =>
        loggedUserId != null
            ? const AuthStateUserIsSignedIn()
            : const AuthStateUserIsSignedOut(),
  );

  @override
  Future<void> signInWithGoogle() async {
    await _dbAuthService.signInWithGoogle();
  }
}
