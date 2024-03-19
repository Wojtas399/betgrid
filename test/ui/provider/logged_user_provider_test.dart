import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/provider/logged_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_user_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthRepository();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authService),
        userRepositoryProvider.overrideWithValue(userRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  test(
    'build, '
    'logged user id is null'
    'should emit null',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(loggedUserProvider.future),
        completion(null),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<User?>(),
            ),
        () => listener(
              const AsyncLoading<User?>(),
              const AsyncData<User?>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'build, '
    'should emit logged user data got directly from user repository',
    () async {
      final User loggedUserData = createUser(
        id: loggedUserId,
        username: 'username',
      );
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: loggedUserData);
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(loggedUserProvider.future),
        completion(loggedUserData),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<User?>(),
            ),
        () => listener(
              const AsyncLoading<User?>(),
              AsyncData<User?>(loggedUserData),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
