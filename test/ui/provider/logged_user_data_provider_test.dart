import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/riverpod_provider/logged_user_data_provider.dart';
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
        loggedUserDataProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(loggedUserDataProvider.future),
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
      final User loggedUserData = createUser(id: loggedUserId, nick: 'nick');
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: loggedUserData);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(loggedUserDataProvider.future),
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
      const String nick = 'nick';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataProvider.notifier).addLoggedUserData(
            nick: nick,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
          );

      verifyNever(
        () => userRepository.addUser(
          userId: loggedUserId,
          nick: nick,
          avatarImgPath: avatarImgPath,
          themeMode: themeMode,
        ),
      );
    },
  );

  test(
    'addLoggedUserData, '
    'should call method from UserRepository to add user data',
    () async {
      const String nick = 'nick';
      const String avatarImgPath = 'avatar/img';
      const ThemeMode themeMode = ThemeMode.system;
      authService.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById();
      userRepository.mockAddUser();
      final container = makeProviderContainer(authService, userRepository);
      final listener = Listener<AsyncValue<User?>>();
      container.listen(
        loggedUserDataProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(loggedUserDataProvider.future);
      await container.read(loggedUserDataProvider.notifier).addLoggedUserData(
            nick: nick,
            avatarImgPath: avatarImgPath,
            themeMode: themeMode,
          );

      verify(
        () => userRepository.addUser(
          userId: loggedUserId,
          nick: nick,
          avatarImgPath: avatarImgPath,
          themeMode: themeMode,
        ),
      ).called(1);
    },
  );
}
