import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/data/repository/auth/auth_repository_method_providers.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/controller/logged_user/logged_user_controller.dart';
import 'package:betgrid/ui/controller/logged_user/logged_user_controller_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/data/repository/mock_user_repository.dart';
import '../../mock/listener.dart';

void main() {
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  ProviderContainer makeProviderContainer({
    String? loggedUserId,
  }) {
    final container = ProviderContainer(
      overrides: [
        loggedUserIdProvider.overrideWith((_) => Stream.value(loggedUserId)),
        userRepositoryProvider.overrideWithValue(userRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(
      const AsyncData(LoggedUserControllerStateInitial()),
    );
  });

  tearDown(() {
    reset(userRepository);
  });

  test(
    'build, '
    'should emit initial state',
    () async {
      const expectedState = LoggedUserControllerStateInitial();
      final container = makeProviderContainer();

      final state = await container.read(loggedUserControllerProvider.future);

      expect(state, expectedState);
    },
  );

  test(
    'addData, '
    'username is empty, '
    'should emit empty username error',
    () async {
      const String username = '';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.blue;
      const expectedError = LoggedUserControllerStateEmptyUsername();
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();

      Object? error;
      container.listen(
        loggedUserControllerProvider,
        (prev, next) {
          listener(prev, next);
          if (next is AsyncError) error = next.error;
        },
        fireImmediately: true,
      );
      await container.read(loggedUserControllerProvider.future);
      await container.read(loggedUserControllerProvider.notifier).addData(
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );

      expect(error, expectedError);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'addData, '
    'logged user id is null, '
    'should emit logged user id not found error',
    () async {
      const String username = 'username';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.blue;
      const expectedError = LoggedUserControllerStateLoggedUserIdNotFound();
      final container = makeProviderContainer(loggedUserId: null);
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();

      Object? error;
      container.listen(
        loggedUserControllerProvider,
        (prev, next) {
          listener(prev, next);
          if (next is AsyncError) error = next.error;
        },
        fireImmediately: true,
      );
      await container.read(loggedUserControllerProvider.future);
      await container.read(loggedUserControllerProvider.notifier).addData(
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );

      expect(error, expectedError);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'addData, '
    'username is already taken, '
    'should emit username already taken error',
    () async {
      const String username = 'username';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      const expectedError =
          LoggedUserControllerStateNewUsernameIsAlreadyTaken();
      userRepository.mockAddUser(
        throwable: const UserRepositoryExceptionUsernameAlreadyTaken(),
      );
      final container = makeProviderContainer(loggedUserId: loggedUserId);
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();

      Object? error;
      container.listen(
        loggedUserControllerProvider,
        (prev, curr) {
          listener(prev, curr);
          if (curr is AsyncError) error = curr.error;
        },
        fireImmediately: true,
      );
      await container.read(loggedUserControllerProvider.future);
      await container.read(loggedUserControllerProvider.notifier).addData(
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );

      expect(error, expectedError);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
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

  test(
    'addData, '
    'should call method from UserRepository to add user data and should emit '
    'DataSaved state',
    () async {
      const String username = 'username';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      userRepository.mockAddUser();
      final container = makeProviderContainer(loggedUserId: loggedUserId);
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();
      container.listen(
        loggedUserControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(loggedUserControllerProvider.future);
      await container.read(loggedUserControllerProvider.notifier).addData(
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateDataSaved(),
              ),
            ),
      ]);
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

  test(
    'updateUsername, '
    'username is empty, '
    'should emit empty username error',
    () async {
      const String newUsername = '';
      const expectedError = LoggedUserControllerStateEmptyUsername();
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();

      Object? error;
      container.listen(
        loggedUserControllerProvider,
        (prev, next) {
          listener(prev, next);
          if (next is AsyncError) error = next.error;
        },
        fireImmediately: true,
      );
      await container.read(loggedUserControllerProvider.future);
      await container
          .read(loggedUserControllerProvider.notifier)
          .updateUsername(newUsername);

      expect(error, expectedError);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'updateUsername, '
    'logged user id is null, '
    'should emit logged user id not found error',
    () async {
      const String newUsername = 'new username';
      const expectedError = LoggedUserControllerStateLoggedUserIdNotFound();
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();

      Object? error;
      container.listen(
        loggedUserControllerProvider,
        (prev, next) {
          listener(prev, next);
          if (next is AsyncError) error = next.error;
        },
        fireImmediately: true,
      );
      await container.read(loggedUserControllerProvider.future);
      await container
          .read(loggedUserControllerProvider.notifier)
          .updateUsername(newUsername);

      expect(error, expectedError);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'updateUsername, '
    'new username is already taken, '
    'should emit username already taken error',
    () async {
      const String newUsername = 'new username';
      const expectedError =
          LoggedUserControllerStateNewUsernameIsAlreadyTaken();
      userRepository.mockUpdateUserData(
        throwable: const UserRepositoryExceptionUsernameAlreadyTaken(),
      );
      final container = makeProviderContainer(loggedUserId: loggedUserId);
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();

      Object? error;
      container.listen(
        loggedUserControllerProvider,
        (prev, curr) {
          listener(prev, curr);
          if (curr is AsyncError) error = curr.error;
        },
        fireImmediately: true,
      );
      await container.read(loggedUserControllerProvider.future);
      await container
          .read(loggedUserControllerProvider.notifier)
          .updateUsername(newUsername);

      expect(error, expectedError);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => userRepository.updateUserData(
          userId: loggedUserId,
          username: newUsername,
        ),
      ).called(1);
    },
  );

  test(
    'updateUsername, '
    'should call method from UserRepository to update user data with new username '
    'and should emit UsernameUpdated state',
    () async {
      const String newUsername = 'new username';
      userRepository.mockUpdateUserData();
      final container = makeProviderContainer(loggedUserId: loggedUserId);
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();
      container.listen(
        loggedUserControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(loggedUserControllerProvider.future);
      await container
          .read(loggedUserControllerProvider.notifier)
          .updateUsername(newUsername);

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateUsernameUpdated(),
              ),
            ),
      ]);
      verify(
        () => userRepository.updateUserData(
          userId: loggedUserId,
          username: newUsername,
        ),
      ).called(1);
    },
  );

  test(
    'updateAvatar, '
    'logged user id is null, '
    'should emit logged user id not found error',
    () async {
      const String newAvatarImgPath = 'avatar/path';
      const expectedError = LoggedUserControllerStateLoggedUserIdNotFound();
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();

      Object? error;
      container.listen(
        loggedUserControllerProvider,
        (prev, next) {
          listener(prev, next);
          if (next is AsyncError) error = next.error;
        },
        fireImmediately: true,
      );
      await container.read(loggedUserControllerProvider.future);
      await container
          .read(loggedUserControllerProvider.notifier)
          .updateAvatar(newAvatarImgPath);

      expect(error, expectedError);
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncError>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'updateAvatar, '
    'should call method from user repository to update user avatar and should '
    'emit AvatarUpdated state',
    () async {
      const String newAvatarImgPath = 'avatar/path';
      userRepository.mockUpdateUserAvatar();
      final container = makeProviderContainer(loggedUserId: loggedUserId);
      final listener = Listener<AsyncValue<LoggedUserControllerState>>();
      container.listen(
        loggedUserControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(loggedUserControllerProvider.future);
      await container
          .read(loggedUserControllerProvider.notifier)
          .updateAvatar(newAvatarImgPath);

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<LoggedUserControllerState>(),
            ),
        () => listener(
              const AsyncLoading<LoggedUserControllerState>(),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
            ),
        () => listener(
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateInitial(),
              ),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<LoggedUserControllerState>(
                LoggedUserControllerStateAvatarUpdated(),
              ),
            ),
      ]);
      verify(
        () => userRepository.updateUserAvatar(
          userId: loggedUserId,
          avatarImgPath: newAvatarImgPath,
        ),
      ).called(1);
    },
  );
}
