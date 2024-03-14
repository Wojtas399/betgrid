import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/model/auth_state.dart';
import 'package:betgrid/ui/controller/sign_in_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authRepository = MockAuthRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<AuthState>());
  });

  tearDown(() {
    reset(authRepository);
  });

  test(
    'signInWithGoogle, '
    'should call signInWithGoogle method from AuthRepository',
    () async {
      authRepository.mockSignInWithGoogle();
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<void>>();
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
              const AsyncLoading<void>(),
            ),
        () => listener(
              const AsyncLoading<void>(),
              const AsyncData<void>(null),
            ),
        () => listener(
              const AsyncData<void>(null),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<void>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signInWithGoogle).called(1);
    },
  );
}
