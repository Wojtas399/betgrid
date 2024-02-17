import '../dependency_injection.dart';
import '../firebase/service/firebase_auth_service.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuthService _firebaseAuthService;

  AuthServiceImpl() : _firebaseAuthService = getIt<FirebaseAuthService>();

  @override
  Stream<String?> get loggedUserId$ => _firebaseAuthService.loggedUserId$;

  @override
  Future<String?> signInWithGoogle() async {
    final String? userId = await _firebaseAuthService.signInWithGoogle();
    return userId;
  }
}
