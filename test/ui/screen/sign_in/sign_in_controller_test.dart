import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/ui/screen/sign_in/controller/sign_in_controller.dart';
import 'package:betgrid/ui/screen/sign_in/state/sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_creator.dart';
import '../../../mock/auth/mock_auth_service.dart';
import '../../../mock/listener.dart';

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
    registerFallbackValue(const AsyncLoading<SignInState>());
  });

  tearDown(() {
    reset(authService);
  });

  test(
    'build, '
    'logged user does not exists, '
    'should get logged user data from AuthService and '
    'should emit SignInStateComplete',
    () async {
      authService.mockGetLoggedUser(null);
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<SignInState>>();
      container.listen(
        signInControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(signInControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<SignInState>(),
            ),
        () => listener(
              const AsyncLoading<SignInState>(),
              const AsyncData<SignInState>(SignInStateComplete()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUser$).called(1);
    },
  );

  test(
    'build, '
    'logged user exists, '
    'should get logged user data from AuthService and '
    'should emit SignInStateUserIsSignedIn',
    () async {
      authService.mockGetLoggedUser(createUser());
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<SignInState>>();
      container.listen(
        signInControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(signInControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<SignInState>(),
            ),
        () => listener(
              const AsyncLoading<SignInState>(),
              const AsyncData<SignInState>(SignInStateUserIsSignedIn()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUser$).called(1);
    },
  );

  test(
    'signInWithGoogle, '
    'user is null, '
    'should call signInWithGoogle method from AuthService and '
    'should emit SignInStateComplete state',
    () async {
      authService.mockGetLoggedUser(null);
      authService.mockSignInWithGoogle(null);
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<SignInState>>();
      container.listen(
        signInControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(signInControllerProvider.notifier);

      await controller.future;
      await controller.signInWithGoogle();

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<SignInState>(),
            ),
        () => listener(
              const AsyncLoading<SignInState>(),
              const AsyncData<SignInState>(SignInStateComplete()),
            ),
        () => listener(
              const AsyncData<SignInState>(SignInStateComplete()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<SignInState>(SignInStateComplete()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUser$).called(1);
      verify(authService.signInWithGoogle).called(1);
    },
  );

  test(
    'signInWithGoogle, '
    'user is not null, '
    'should call signInWithGoogle method from AuthService and '
    'should emit SignInStateUserIsSignedIn state',
    () async {
      authService.mockGetLoggedUser(null);
      authService.mockSignInWithGoogle(createUser());
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<SignInState>>();
      container.listen(
        signInControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(signInControllerProvider.notifier);

      await controller.future;
      await controller.signInWithGoogle();

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<SignInState>(),
            ),
        () => listener(
              const AsyncLoading<SignInState>(),
              const AsyncData<SignInState>(SignInStateComplete()),
            ),
        () => listener(
              const AsyncData<SignInState>(SignInStateComplete()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<SignInState>(SignInStateUserIsSignedIn()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authService.signInWithGoogle).called(1);
    },
  );
}
