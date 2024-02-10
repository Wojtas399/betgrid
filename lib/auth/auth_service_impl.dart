import '../dependency_injection.dart';
import '../firebase/model/user_dto/user_dto.dart';
import '../firebase/service/firebase_auth_service.dart';
import '../model/user.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuthService _firebaseAuthService;

  AuthServiceImpl() : _firebaseAuthService = getIt<FirebaseAuthService>();

  @override
  Stream<String?> get loggedUserId$ => _firebaseAuthService.loggedUser$.map(
        (UserDto? userDto) => userDto?.id,
      );

  @override
  Future<User?> signInWithGoogle() async {
    final UserDto? userDto = await _firebaseAuthService.signInWithGoogle();
    if (userDto == null) return null;
    return User(id: userDto.id, email: userDto.email);
  }
}
