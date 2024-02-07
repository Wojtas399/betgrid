import '../model/user.dart';

abstract interface class AuthService {
  Future<User?> signInWithGoogle();
}
