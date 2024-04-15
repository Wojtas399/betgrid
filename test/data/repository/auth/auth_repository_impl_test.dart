import 'package:betgrid/data/repository/auth/auth_repository_impl.dart';
import 'package:betgrid/model/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/firebase/mock_firebase_auth_service.dart';

void main() {
  final dbAuthService = MockFirebaseAuthService();
  late AuthRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = AuthRepositoryImpl(firebaseAuthService: dbAuthService);
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
    'should call method from db to sign in with google',
    () async {
      dbAuthService.mockSignInWithGoogle(null);

      await repositoryImpl.signInWithGoogle();

      verify(dbAuthService.signInWithGoogle).called(1);
    },
  );
}
