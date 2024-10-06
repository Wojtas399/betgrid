import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/common_cubit/theme_cubit.dart';
import 'package:betgrid/ui/common_cubit/theme_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  ThemeCubit createCubit() => ThemeCubit(
        authRepository,
        userRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
  });

  group(
    'initialize, ',
    () {
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;

      blocTest(
        'should emit state with default params if logged user id is null',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(null),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const ThemeState(),
        ],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
      );

      blocTest(
        'should do nothing if logged user data is null',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(user: null);
        },
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const ThemeState(),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );

      blocTest(
        "should emit logged user's theme mode and primary color",
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(
            user: const User(
              id: loggedUserId,
              username: 'username',
              themeMode: themeMode,
              themePrimaryColor: themePrimaryColor,
            ),
          );
        },
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const ThemeState(
            themeMode: themeMode,
            primaryColor: themePrimaryColor,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  group(
    'changeThemeMode, ',
    () {
      const ThemeMode newThemeMode = ThemeMode.light;

      blocTest(
        'should emit previous state if logged user id is null',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(null),
        act: (cubit) async {
          await cubit.initialize();
          await cubit.changeThemeMode(newThemeMode);
        },
        expect: () => [
          const ThemeState(),
          const ThemeState(themeMode: newThemeMode),
          const ThemeState(),
        ],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(2),
      );

      blocTest(
        'should emit previous state if method to update user data throws '
        'UserNotFound exception',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(user: null);
          userRepository.mockUpdateUserData(
            throwable: const UserRepositoryExceptionUserNotFound(),
          );
        },
        act: (cubit) async {
          await cubit.initialize();
          await cubit.changeThemeMode(newThemeMode);
        },
        expect: () => [
          const ThemeState(),
          const ThemeState(themeMode: newThemeMode),
          const ThemeState(),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.updateUserData(
              userId: loggedUserId,
              themeMode: newThemeMode,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should call method from UserRepository to update user data with new '
        'theme mode',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(user: null);
          userRepository.mockUpdateUserData();
        },
        act: (cubit) async {
          await cubit.initialize();
          await cubit.changeThemeMode(newThemeMode);
        },
        expect: () => [
          const ThemeState(),
          const ThemeState(themeMode: newThemeMode),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.updateUserData(
              userId: loggedUserId,
              themeMode: newThemeMode,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'changePrimaryColor, ',
    () {
      const ThemePrimaryColor newThemePrimaryColor = ThemePrimaryColor.blue;

      blocTest(
        'should emit previous state if logged user id is null',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(null),
        act: (cubit) async {
          await cubit.initialize();
          await cubit.changePrimaryColor(newThemePrimaryColor);
        },
        expect: () => [
          const ThemeState(),
          const ThemeState(primaryColor: newThemePrimaryColor),
          const ThemeState(),
        ],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(2),
      );

      blocTest(
        'should emit previous state if method to update user data throws '
        'UserNotFound exception',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(user: null);
          userRepository.mockUpdateUserData(
            throwable: const UserRepositoryExceptionUserNotFound(),
          );
        },
        act: (cubit) async {
          await cubit.initialize();
          await cubit.changePrimaryColor(newThemePrimaryColor);
        },
        expect: () => [
          const ThemeState(),
          const ThemeState(primaryColor: newThemePrimaryColor),
          const ThemeState(),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.updateUserData(
              userId: loggedUserId,
              themePrimaryColor: newThemePrimaryColor,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should call method from UserRepository to update user data with new '
        'theme primary color',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(user: null);
          userRepository.mockUpdateUserData();
        },
        act: (cubit) async {
          await cubit.initialize();
          await cubit.changePrimaryColor(newThemePrimaryColor);
        },
        expect: () => [
          const ThemeState(),
          const ThemeState(primaryColor: newThemePrimaryColor),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.updateUserData(
              userId: loggedUserId,
              themePrimaryColor: newThemePrimaryColor,
            ),
          ).called(1);
        },
      );
    },
  );
}
