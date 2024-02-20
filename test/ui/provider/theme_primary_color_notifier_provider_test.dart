import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/provider/theme_primary_color_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/auth/mock_auth_service.dart';
import '../../mock/data/repository/mock_user_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  ProviderContainer makeProviderContainer(
    MockAuthService authService,
    MockUserRepository userRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
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
    'logged user id does not exist, '
    'should emit ThemePrimaryColor.defaultRed',
    () async {
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.defaultRed;
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themePrimaryColorNotifierProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'build, '
    'logged user data does not exist, '
    'should emit ThemePrimaryColor.defaultRed',
    () async {
      const String loggedUserId = 'u1';
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.defaultRed;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themePrimaryColorNotifierProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'build, '
    'should get logged user data from UserRepository and emit its theme primary color',
    () async {
      const String loggedUserId = 'u1';
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.purple;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(themePrimaryColor: expectedThemePrimaryColor),
      );
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themePrimaryColorNotifierProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.getUserById(userId: loggedUserId),
      ).called(1);
    },
  );

  test(
    'changeThemePrimaryColor, '
    'should update theme primary color in state',
    () async {
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.green;
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(themePrimaryColorNotifierProvider.future);
      container
          .read(themePrimaryColorNotifierProvider.notifier)
          .changeThemePrimaryColor(
            expectedThemePrimaryColor,
          );

      await expectLater(
        container.read(themePrimaryColorNotifierProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(ThemePrimaryColor.defaultRed),
            ),
        () => listener(
              const AsyncData<ThemePrimaryColor>(ThemePrimaryColor.defaultRed),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
