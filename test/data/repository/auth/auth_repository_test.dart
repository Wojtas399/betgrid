import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/firebase/service/firebase_auth_service.dart';
import 'package:betgrid/model/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/firebase/mock_firebase_auth_service.dart';

void main() {
  final dbAuthService = MockFirebaseAuthService();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        firebaseAuthServiceProvider.overrideWithValue(dbAuthService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(dbAuthService);
  });

  test(
    'authState, '
    'should emit AuthStateUserIsSignedOut if logged user id got from db is null',
    () {
      dbAuthService.mockGetLoggedUserId(null);
      final container = makeProviderContainer();

      final Stream<AuthState?> authState$ =
          container.read(authRepositoryProvider).authState$;

      expect(authState$, emits(const AuthStateUserIsSignedOut()));
    },
  );

  test(
    'authState, '
    'should emit AuthStateUserIsSignedIn if logged user id got from db is not null',
    () {
      dbAuthService.mockGetLoggedUserId('u1');
      final container = makeProviderContainer();

      final Stream<AuthState?> authState$ =
          container.read(authRepositoryProvider).authState$;

      expect(authState$, emits(const AuthStateUserIsSignedIn()));
    },
  );

  test(
    'loggedUserId, '
    'should emit id of logged user got from firebase',
    () {
      const String id = 'u1';
      dbAuthService.mockGetLoggedUserId(id);
      final container = makeProviderContainer();

      final Stream<String?> loggedUserId$ =
          container.read(authRepositoryProvider).loggedUserId$;

      expect(loggedUserId$, emits(id));
    },
  );

  test(
    'signInWithGoogle, '
    'should call method from db to sign in with google',
    () async {
      dbAuthService.mockSignInWithGoogle(null);
      final container = makeProviderContainer();

      await container.read(authRepositoryProvider).signInWithGoogle();

      verify(dbAuthService.signInWithGoogle).called(1);
    },
  );
}
