import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/ui/riverpod_provider/auth/auth_provider.dart';
import 'package:betgrid/ui/riverpod_provider/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/auth/mock_auth_service.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();

  ProviderContainer makeProviderContainer(MockAuthService authService) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<AuthState>());
  });

  tearDown(() {
    reset(authService);
  });

  test(
    'build, '
    'logged user does not exists, '
    'should get logged user data from AuthService and '
    'should emit AuthStateComplete',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<AuthState>>();
      container.listen(
        authProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(authProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<AuthState>(),
            ),
        () => listener(
              const AsyncLoading<AuthState>(),
              const AsyncData<AuthState>(AuthStateComplete()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
    },
  );

  test(
    'build, '
    'logged user exists, '
    'should get logged user data from AuthService and '
    'should emit AuthStateUserIsSignedIn',
    () async {
      authService.mockGetLoggedUserId('u1');
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<AuthState>>();
      container.listen(
        authProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(authProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<AuthState>(),
            ),
        () => listener(
              const AsyncLoading<AuthState>(),
              const AsyncData<AuthState>(AuthStateUserIsSignedIn()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
    },
  );

  test(
    'signInWithGoogle, '
    'user is null, '
    'should call AuthWithGoogle method from AuthService and '
    'should emit AuthStateComplete state',
    () async {
      authService.mockGetLoggedUserId(null);
      authService.mockSignInWithGoogle(null);
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<AuthState>>();
      container.listen(
        authProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(authProvider.notifier);

      await controller.future;
      await controller.signInWithGoogle();

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<AuthState>(),
            ),
        () => listener(
              const AsyncLoading<AuthState>(),
              const AsyncData<AuthState>(AuthStateComplete()),
            ),
        () => listener(
              const AsyncData<AuthState>(AuthStateComplete()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<AuthState>(AuthStateComplete()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(authService.signInWithGoogle).called(1);
    },
  );

  test(
    'signInWithGoogle, '
    'user is not null, '
    'should call AuthWithGoogle method from AuthService and '
    'should emit AuthStateUserIsSignedIn state',
    () async {
      authService.mockGetLoggedUserId(null);
      authService.mockSignInWithGoogle(createUser());
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<AuthState>>();
      container.listen(
        authProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(authProvider.notifier);

      await controller.future;
      await controller.signInWithGoogle();

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<AuthState>(),
            ),
        () => listener(
              const AsyncLoading<AuthState>(),
              const AsyncData<AuthState>(AuthStateComplete()),
            ),
        () => listener(
              const AsyncData<AuthState>(AuthStateComplete()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<AuthState>(AuthStateUserIsSignedIn()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authService.signInWithGoogle).called(1);
    },
  );
}
