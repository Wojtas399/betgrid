import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/provider/logged_user_data_notifier_provider.dart';
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
  const String loggedUserId = 'u1';

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
    'logged user id is null'
    'should emit null',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(loggedUserDataNotifierProvider.future),
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
    'should get end emit logged user data',
    () async {
      final User loggedUserData = createUser(
        id: loggedUserId,
        username: 'username',
      );
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: loggedUserData);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(loggedUserDataNotifierProvider.future),
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

  test(
    'addLoggedUserData, '
    'logged user id is null'
    'should do nothing',
    () async {
      const String username = 'username';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.blue;
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container
          .read(loggedUserDataNotifierProvider.notifier)
          .addLoggedUserData(
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );

      verifyNever(
        () => userRepository.addUser(
          userId: loggedUserId,
          username: username,
          avatarImgPath: avatarImgPath,
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
      );
    },
  );

  test(
    'addLoggedUserData, '
    'should call method from UserRepository to add user data',
    () async {
      const String username = 'username';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById();
      userRepository.mockAddUser();
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataNotifierProvider.future);
      await container
          .read(loggedUserDataNotifierProvider.notifier)
          .addLoggedUserData(
            username: username,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
            themePrimaryColor: themePrimaryColor,
          );

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
    'logged user id is null, '
    'should do nothing',
    () async {
      const String newUsername = 'new username';
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataNotifierProvider.future);
      await container
          .read(loggedUserDataNotifierProvider.notifier)
          .updateUsername(newUsername);

      verifyNever(
        () => userRepository.updateUserData(
          userId: loggedUserId,
          username: newUsername,
        ),
      );
    },
  );

  test(
    'updateUsername, '
    'new username is already taken, '
    'should throw LoggedUserDataNotifierExceptionNewUsernameIsAlreadyTaken exception',
    () async {
      const String newUsername = 'new username';
      const expectedException =
          LoggedUserDataNotifierExceptionNewUsernameIsAlreadyTaken();
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: null);
      userRepository.mockUpdateUserData(throwable: expectedException);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataNotifierProvider.future);
      Object? exception;
      try {
        await container
            .read(loggedUserDataNotifierProvider.notifier)
            .updateUsername(newUsername);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
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
    'should call method from UserRepository to update user data with new username',
    () async {
      const String newUsername = 'new username';
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: null);
      userRepository.mockUpdateUserData();
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataNotifierProvider.future);
      await container
          .read(loggedUserDataNotifierProvider.notifier)
          .updateUsername(newUsername);

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
    'should do nothing',
    () async {
      const String newAvatarImgPath = 'avatar/path';
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataNotifierProvider.future);
      await container
          .read(loggedUserDataNotifierProvider.notifier)
          .updateAvatar(newAvatarImgPath);

      verifyNever(
        () => userRepository.updateUserAvatar(
          userId: any(named: 'userId'),
          avatarImgPath: any(named: 'avatarImgPath'),
        ),
      );
    },
  );

  test(
    'updateAvatar, '
    'should call method from user repository to update user avatar',
    () async {
      const String newAvatarImgPath = 'avatar/path';
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: null);
      userRepository.mockUpdateUserAvatar();
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataNotifierProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataNotifierProvider.future);
      await container
          .read(loggedUserDataNotifierProvider.notifier)
          .updateAvatar(newAvatarImgPath);

      verify(
        () => userRepository.updateUserAvatar(
          userId: loggedUserId,
          avatarImgPath: newAvatarImgPath,
        ),
      ).called(1);
    },
  );
}
