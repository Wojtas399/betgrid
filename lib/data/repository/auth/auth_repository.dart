import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/service/firebase_auth_service.dart';
import '../../../model/auth_state.dart';
import 'auth_repository_impl.dart';

part 'auth_repository.g.dart';

abstract interface class AuthRepository {
  Stream<AuthState> get authState$;

  Stream<String?> get loggedUserId$;

  Future<void> signInWithGoogle();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepositoryImpl(
      getIt.get<FirebaseAuthService>(),
    );
