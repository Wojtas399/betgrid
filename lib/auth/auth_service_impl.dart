import '../firebase/model/user_dto/user_dto.dart';
import '../firebase/service/firebase_auth_service.dart';
import '../model/user.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuthService _firebaseAuthService;

  const AuthServiceImpl(FirebaseAuthService firebaseAuthService)
      : _firebaseAuthService = firebaseAuthService;

  @override
  Future<User?> signInWithGoogle() async {
    final UserDto? userDto = await _firebaseAuthService.signInWithGoogle();
    if (userDto == null) return null;
    return User(id: userDto.id, email: userDto.email);
  }
}
