import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../firebase/service/firebase_auth_service.dart';
import '../model/user.dart';
import 'auth_service_impl.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) =>
    AuthServiceImpl(FirebaseAuthService());

abstract interface class AuthService {
  Stream<User?> get loggedUser$;

  Future<User?> signInWithGoogle();
}
