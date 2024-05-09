import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/controller/theme_mode_controller.dart';
import 'package:betgrid/ui/provider/logged_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/data/repository/mock_user_repository.dart';
import '../../mock/listener.dart';

void main() {
  final userRepository = MockUserRepository();

  ProviderContainer makeProviderContainer({User? loggedUser}) {
    final container = ProviderContainer(
      overrides: [
        loggedUserProvider.overrideWith((_) => Future.value(loggedUser)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerLazySingleton<UserRepository>(() => userRepository);
  });

  tearDown(() {
    reset(userRepository);
  });

  test(
    'build, '
    'logged user does not exist, '
    'should emit ThemeMode.system',
    () async {
      const ThemeMode expectedThemeMode = ThemeMode.system;
      final container = makeProviderContainer(loggedUser: null);
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themeModeControllerProvider.future),
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
    'should get logged user data from its provider and should emit its theme mode',
    () async {
      const String loggedUserId = 'u1';
      const ThemeMode expectedThemeMode = ThemeMode.dark;
      final container = makeProviderContainer(
        loggedUser: createUser(id: loggedUserId, themeMode: expectedThemeMode),
      );
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themeModeControllerProvider.future),
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
    'changeThemeMode, '
    'logged user does not exist, '
    'should only update theme mode in state',
    () async {
      const ThemeMode expectedThemeMode = ThemeMode.system;
      final container = makeProviderContainer(loggedUser: null);
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(themeModeControllerProvider.future);
      container
          .read(themeModeControllerProvider.notifier)
          .changeThemeMode(expectedThemeMode);

      await expectLater(
        container.read(themeModeControllerProvider.future),
        completion(expectedThemeMode),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemeMode>(),
            ),
        () => listener(
              const AsyncLoading<ThemeMode>(),
              const AsyncData<ThemeMode>(ThemeMode.system),
            ),
        () => listener(
              const AsyncData<ThemeMode>(ThemeMode.system),
              const AsyncData<ThemeMode>(expectedThemeMode),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verifyNever(
        () => userRepository.updateUserData(
          userId: any(named: 'userId'),
          themeMode: expectedThemeMode,
        ),
      );
    },
  );

  test(
    'changeThemeMode, '
    'logged user exists, '
    'should update theme mode in state and should call method from UserRepository '
    "to update user's data with new theme mode",
    () async {
      const String loggedUserId = 'u1';
      const ThemeMode expectedThemeMode = ThemeMode.system;
      userRepository.mockUpdateUserData();
      final container = makeProviderContainer(
        loggedUser: createUser(id: loggedUserId, themeMode: ThemeMode.dark),
      );
      final listener = Listener<AsyncValue<ThemeMode>>();
      container.listen(
        themeModeControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(themeModeControllerProvider.future);
      container.read(themeModeControllerProvider.notifier).changeThemeMode(
            expectedThemeMode,
          );

      await expectLater(
        container.read(themeModeControllerProvider.future),
        completion(expectedThemeMode),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemeMode>(),
            ),
        () => listener(
              const AsyncLoading<ThemeMode>(),
              const AsyncData<ThemeMode>(ThemeMode.dark),
            ),
        () => listener(
              const AsyncData<ThemeMode>(ThemeMode.dark),
              const AsyncData<ThemeMode>(expectedThemeMode),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => userRepository.updateUserData(
          userId: loggedUserId,
          themeMode: expectedThemeMode,
        ),
      ).called(1);
    },
  );
}
