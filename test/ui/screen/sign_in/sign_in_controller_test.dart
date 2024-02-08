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
    'signInWithGoogle, '
    'user is null, '
    'should emit SignInStateComplete',
    () async {
      authService.mockSignInWithGoogle(null);
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<SignInState>>();
      container.listen(
        signInControllerProvider,
        listener,
        fireImmediately: true,
      );

      await container
          .read(signInControllerProvider.notifier)
          .signInWithGoogle();

      verifyInOrder([
        () => listener(
              null,
              const AsyncData<SignInState>(SignInStateInitial()),
            ),
        () => listener(
              const AsyncData<SignInState>(SignInStateInitial()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<SignInState>(SignInStateComplete()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authService.signInWithGoogle).called(1);
    },
  );

  test(
    'signInWithGoogle, '
    'user is not null, '
    'should emit SignInStateUserIsSignedIn',
    () async {
      authService.mockSignInWithGoogle(createUser());
      final container = makeProviderContainer(authService);
      final listener = Listener<AsyncValue<SignInState>>();
      container.listen(
        signInControllerProvider,
        listener,
        fireImmediately: true,
      );

      await container
          .read(signInControllerProvider.notifier)
          .signInWithGoogle();

      verifyInOrder([
        () => listener(
              null,
              const AsyncData<SignInState>(SignInStateInitial()),
            ),
        () => listener(
              const AsyncData<SignInState>(SignInStateInitial()),
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
