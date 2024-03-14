import 'package:betgrid/data/repository/auth/auth_repository_impl.dart';
import 'package:betgrid/firebase/service/firebase_auth_service.dart';
import 'package:betgrid/model/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/firebase/mock_firebase_auth_service.dart';

void main() {
  final dbAuthService = MockFirebaseAuthService();
  late AuthRepositoryImpl repositoryImpl;

  setUpAll(() {
    GetIt.instance.registerFactory<FirebaseAuthService>(() => dbAuthService);
  });

  setUp(() {
    repositoryImpl = AuthRepositoryImpl();
  });

  tearDown(() {
    reset(dbAuthService);
  });

  test(
    'authState, '
    'should emit AuthStateUserIsSignedOut if logged user id got from db is null',
    () {
      dbAuthService.mockGetLoggedUserId(null);

      final Stream<AuthState?> authState$ = repositoryImpl.authState$;

      expect(authState$, emits(const AuthStateUserIsSignedOut()));
    },
  );

  test(
    'authState, '
    'should emit AuthStateUserIsSignedIn if logged user id got from db is not null',
    () {
      dbAuthService.mockGetLoggedUserId('u1');

      final Stream<AuthState?> authState$ = repositoryImpl.authState$;

      expect(authState$, emits(const AuthStateUserIsSignedIn()));
    },
  );

  test(
    'loggedUserId, '
    'should emit id of logged user got from firebase',
    () {
      const String id = 'u1';
      dbAuthService.mockGetLoggedUserId(id);

      final Stream<String?> loggedUserId$ = repositoryImpl.loggedUserId$;

      expect(loggedUserId$, emits(id));
    },
  );

  test(
    'signInWithGoogle, '
    'user does not exist, '
    'should return null',
    () async {
      dbAuthService.mockSignInWithGoogle(null);

      final String? userId = await repositoryImpl.signInWithGoogle();

      expect(userId, null);
    },
  );

  test(
    'signInWithGoogle, '
    'user exists, '
    'should return user id',
    () async {
      const String expectedUserId = 'u1';
      dbAuthService.mockSignInWithGoogle(expectedUserId);

      final String? userId = await repositoryImpl.signInWithGoogle();

      expect(userId, expectedUserId);
    },
  );
}
