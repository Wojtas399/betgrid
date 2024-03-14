import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/auth_state.dart';
import 'auth_repository_impl.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepositoryImpl();

abstract interface class AuthRepository {
  Stream<AuthState> get authState$;

  Stream<String?> get loggedUserId$;

  Future<String?> signInWithGoogle();
}
