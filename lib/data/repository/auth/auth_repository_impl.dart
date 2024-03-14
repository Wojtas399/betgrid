import '../../../dependency_injection.dart';
import '../../../firebase/service/firebase_auth_service.dart';
import '../../../model/auth_state.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepositoryImpl() : _firebaseAuthService = getIt<FirebaseAuthService>();

  @override
  Stream<AuthState> get authState$ => _firebaseAuthService.loggedUserId$.map(
        (String? loggedUserId) => loggedUserId != null
            ? const AuthStateUserIsSignedIn()
            : const AuthStateUserIsSignedOut(),
      );

  @override
  Stream<String?> get loggedUserId$ => _firebaseAuthService.loggedUserId$;

  @override
  Future<void> signInWithGoogle() async {
    await _firebaseAuthService.signInWithGoogle();
  }
}
