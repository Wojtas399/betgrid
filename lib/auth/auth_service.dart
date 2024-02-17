import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_service_impl.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) => AuthServiceImpl();

abstract interface class AuthService {
  Stream<String?> get loggedUserId$;

  Future<String?> signInWithGoogle();
}
