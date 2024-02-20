import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/required_data_completion/notifier/required_data_completion_notifier.dart';
import 'package:betgrid/ui/screen/required_data_completion/notifier/required_data_completion_notifier_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
    'updateAvatarImgPath, '
    'should update avatarImgPath in state',
    () async {
      const String avatarImgPath = 'avatar/path';
      final container = makeProviderContainer(authService, userRepository);
      final listener =
          Listener<AsyncValue<RequiredDataCompletionNotifierState>>();
      container.listen(
        requiredDataCompletionNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(requiredDataCompletionNotifierProvider.future);
      container
          .read(requiredDataCompletionNotifierProvider.notifier)
          .updateAvatarImgPath(avatarImgPath);

      await expectLater(
        container.read(requiredDataCompletionNotifierProvider.future),
        completion(const RequiredDataCompletionNotifierState(
          avatarImgPath: avatarImgPath,
        )),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
            ),
        () => listener(
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
              const AsyncData<RequiredDataCompletionNotifierState>(
                RequiredDataCompletionNotifierState(),
              ),
            ),
        () => listener(
              const AsyncData<RequiredDataCompletionNotifierState>(
                RequiredDataCompletionNotifierState(),
              ),
              const AsyncData<RequiredDataCompletionNotifierState>(
                RequiredDataCompletionNotifierState(
                  avatarImgPath: avatarImgPath,
                ),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'updateUsername, '
    'should update username in state',
    () async {
      const String username = 'username';
      final container = makeProviderContainer(authService, userRepository);
      final listener =
          Listener<AsyncValue<RequiredDataCompletionNotifierState>>();
      container.listen(
        requiredDataCompletionNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(requiredDataCompletionNotifierProvider.future);
      container
          .read(requiredDataCompletionNotifierProvider.notifier)
          .updateUsername(username);

      await expectLater(
        container.read(requiredDataCompletionNotifierProvider.future),
        completion(const RequiredDataCompletionNotifierState(
          username: username,
        )),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
            ),
        () => listener(
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
              const AsyncData<RequiredDataCompletionNotifierState>(
                RequiredDataCompletionNotifierState(),
              ),
            ),
        () => listener(
              const AsyncData<RequiredDataCompletionNotifierState>(
                RequiredDataCompletionNotifierState(),
              ),
              const AsyncData<RequiredDataCompletionNotifierState>(
                RequiredDataCompletionNotifierState(username: username),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'submit, '
    'username is empty str, '
    'should emit RequiredDataCompletionNotifierStatusEmptyUsername status',
    () async {
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      final container = makeProviderContainer(authService, userRepository);
      final listener =
          Listener<AsyncValue<RequiredDataCompletionNotifierState>>();
      container.listen(
        requiredDataCompletionNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        requiredDataCompletionNotifierProvider.notifier,
      );

      await container.read(requiredDataCompletionNotifierProvider.future);
      await notifier.submit(
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );

      RequiredDataCompletionNotifierState state =
          const RequiredDataCompletionNotifierState();
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
            ),
        () => listener(
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
              AsyncData<RequiredDataCompletionNotifierState>(state),
            ),
        () {
          final prevState = state;
          state = state.copyWith(
            status: const RequiredDataCompletionNotifierStatusEmptyUsername(),
          );
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
      ]);
      verifyNoMoreInteractions(listener);
      verifyNever(() => authService.loggedUserId$);
      verifyNever(
        () => userRepository.addUser(
          userId: any(named: 'userId'),
          username: any(named: 'username'),
          avatarImgPath: any(named: 'avatarImgPath'),
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
      );
    },
  );

  test(
    'submit, '
    'username is already taken, '
    'should emit RequiredDataCompletionNotifierStatusUsernameAlreadyTaken status',
    () async {
      const String loggedUserId = 'u1';
      const String username = 'username';
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockAddUser(
        throwable: const UserRepositoryExceptionUsernameAlreadyTaken(),
      );
      final container = makeProviderContainer(authService, userRepository);
      final listener =
          Listener<AsyncValue<RequiredDataCompletionNotifierState>>();
      container.listen(
        requiredDataCompletionNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        requiredDataCompletionNotifierProvider.notifier,
      );

      await container.read(requiredDataCompletionNotifierProvider.future);
      notifier.updateUsername(username);
      await notifier.submit(
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );

      RequiredDataCompletionNotifierState state =
          const RequiredDataCompletionNotifierState();
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
            ),
        () => listener(
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
              AsyncData<RequiredDataCompletionNotifierState>(state),
            ),
        () {
          final prevState = state;
          state = state.copyWith(username: username);
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
        () {
          final prevState = state;
          state = state.copyWith(
            status: const RequiredDataCompletionNotifierStatusSavingData(),
          );
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
        () {
          final prevState = state;
          state = state.copyWith(
            status:
                const RequiredDataCompletionNotifierStatusUsernameAlreadyTaken(),
          );
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.addUser(
          userId: loggedUserId,
          username: username,
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
      ).called(1);
    },
  );

  test(
    'submit, '
    'should call method from UserRepository to save user data and should '
    'emit RequiredDataCompletionNotifierStatusDataSaved status',
    () async {
      const String loggedUserId = 'u1';
      const String avatarImgPath = 'avatar/img/path';
      const String username = 'username';
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockAddUser();
      final container = makeProviderContainer(authService, userRepository);
      final listener =
          Listener<AsyncValue<RequiredDataCompletionNotifierState>>();
      container.listen(
        requiredDataCompletionNotifierProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        requiredDataCompletionNotifierProvider.notifier,
      );

      await container.read(requiredDataCompletionNotifierProvider.future);
      notifier.updateAvatarImgPath(avatarImgPath);
      notifier.updateUsername(username);
      await notifier.submit(
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );

      RequiredDataCompletionNotifierState state =
          const RequiredDataCompletionNotifierState();
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
            ),
        () => listener(
              const AsyncLoading<RequiredDataCompletionNotifierState>(),
              AsyncData<RequiredDataCompletionNotifierState>(state),
            ),
        () {
          final prevState = state;
          state = state.copyWith(avatarImgPath: avatarImgPath);
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
        () {
          final prevState = state;
          state = state.copyWith(username: username);
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
        () {
          final prevState = state;
          state = state.copyWith(
            status: const RequiredDataCompletionNotifierStatusSavingData(),
          );
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
        () {
          final prevState = state;
          state = state.copyWith(
            status: const RequiredDataCompletionNotifierStatusDataSaved(),
          );
          return listener(
            AsyncData<RequiredDataCompletionNotifierState>(prevState),
            AsyncData<RequiredDataCompletionNotifierState>(state),
          );
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.addUser(
          userId: loggedUserId,
          username: username,
          avatarImgPath: avatarImgPath,
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
      ).called(1);
    },
  );
}
