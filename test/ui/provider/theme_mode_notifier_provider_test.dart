import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/provider/theme_mode_notifier_provider.dart';
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
    'should emit ThemeMode.light',
    () async {
      const ThemeMode expectedThemeMode = ThemeMode.light;
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themeModeNotifierProvider.future),
        completion(expectedThemeMode),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemeMode>(),
            ),
        () => listener(
              const AsyncLoading<ThemeMode>(),
              const AsyncData<ThemeMode>(expectedThemeMode),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'build, '
    'logged user data does not exist, '
    'should emit ThemeMode.light',
    () async {
      const String loggedUserId = 'u1';
      const ThemeMode expectedThemeMode = ThemeMode.light;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themeModeNotifierProvider.future),
        completion(expectedThemeMode),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemeMode>(),
            ),
        () => listener(
              const AsyncLoading<ThemeMode>(),
              const AsyncData<ThemeMode>(expectedThemeMode),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'build, '
    'should get logged user data from UserRepository and emit its theme mode',
    () async {
      const String loggedUserId = 'u1';
      const ThemeMode expectedThemeMode = ThemeMode.dark;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(themeMode: expectedThemeMode),
      );
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themeModeNotifierProvider.future),
        completion(expectedThemeMode),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemeMode>(),
            ),
        () => listener(
              const AsyncLoading<ThemeMode>(),
              const AsyncData<ThemeMode>(expectedThemeMode),
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
    'changeThemeMode, '
    'should update theme mode in state',
    () async {
      const ThemeMode expectedThemeMode = ThemeMode.system;
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(themeModeNotifierProvider.future);
      container.read(themeModeNotifierProvider.notifier).changeThemeMode(
            expectedThemeMode,
          );

      await expectLater(
        container.read(themeModeNotifierProvider.future),
        completion(expectedThemeMode),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemeMode>(),
            ),
        () => listener(
              const AsyncLoading<ThemeMode>(),
              const AsyncData<ThemeMode>(ThemeMode.light),
            ),
        () => listener(
              const AsyncData<ThemeMode>(ThemeMode.light),
              const AsyncData<ThemeMode>(expectedThemeMode),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
