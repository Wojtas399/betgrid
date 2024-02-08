import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/service/firebase_auth_service.dart';
import '../model/user.dart';
import 'auth_service_impl.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthServiceImpl(FirebaseAuthService()),
);

abstract interface class AuthService {
  Future<User?> signInWithGoogle();
}
