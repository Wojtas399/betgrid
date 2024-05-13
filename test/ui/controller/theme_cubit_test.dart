import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/controller/theme_cubit.dart';
import 'package:betgrid/ui/controller/theme_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  ThemeCubit createCubit() => ThemeCubit(
        authRepository,
        userRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'logged user id is null, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'logged user data is null, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(user: null);
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
    },
  );

  blocTest(
    'initialize, '
    "should emit logged user's theme mode and primary color",
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: createUser(
          themeMode: ThemeMode.dark,
          themePrimaryColor: ThemePrimaryColor.blue,
        ),
      );
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const ThemeState(
        themeMode: ThemeMode.dark,
        primaryColor: ThemePrimaryColor.blue,
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
    },
  );

  blocTest(
    'changeThemeMode, '
    'logged user id is null, '
    'should emit previous state',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) async => await cubit.changeThemeMode(ThemeMode.light),
    expect: () => [
      const ThemeState(themeMode: ThemeMode.light),
      const ThemeState(themeMode: ThemeMode.system),
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'changeThemeMode, '
    'method to update user data throws UserNotFound exception, '
    'should emit previous state',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockUpdateUserData(
        throwable: const UserRepositoryExceptionUserNotFound(),
      );
    },
    act: (cubit) async => await cubit.changeThemeMode(ThemeMode.light),
    expect: () => [
      const ThemeState(themeMode: ThemeMode.light),
      const ThemeState(themeMode: ThemeMode.system),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserData(
          userId: 'u1',
          themeMode: ThemeMode.light,
        ),
      ).called(1);
    },
  );

  blocTest(
    'changeThemeMode, '
    'should call method from UserRepository to update user data with new theme '
    'mode',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockUpdateUserData();
    },
    act: (cubit) async => await cubit.changeThemeMode(ThemeMode.light),
    expect: () => [
      const ThemeState(themeMode: ThemeMode.light),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserData(
          userId: 'u1',
          themeMode: ThemeMode.light,
        ),
      ).called(1);
    },
  );

  blocTest(
    'changePrimaryColor, '
    'logged user id is null, '
    'should emit previous state',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) async => await cubit.changePrimaryColor(
      ThemePrimaryColor.blue,
    ),
    expect: () => [
      const ThemeState(primaryColor: ThemePrimaryColor.blue),
      const ThemeState(primaryColor: ThemePrimaryColor.defaultRed),
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'changePrimaryColor, '
    'method to update user data throws UserNotFound exception, '
    'should emit previous state',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockUpdateUserData(
        throwable: const UserRepositoryExceptionUserNotFound(),
      );
    },
    act: (cubit) async => await cubit.changePrimaryColor(
      ThemePrimaryColor.blue,
    ),
    expect: () => [
      const ThemeState(primaryColor: ThemePrimaryColor.blue),
      const ThemeState(primaryColor: ThemePrimaryColor.defaultRed),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserData(
          userId: 'u1',
          themePrimaryColor: ThemePrimaryColor.blue,
        ),
      ).called(1);
    },
  );

  blocTest(
    'changePrimaryColor, '
    'should call method from UserRepository to update user data with new theme '
    'primary color',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockUpdateUserData();
    },
    act: (cubit) async => await cubit.changePrimaryColor(
      ThemePrimaryColor.blue,
    ),
    expect: () => [
      const ThemeState(primaryColor: ThemePrimaryColor.blue),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserData(
          userId: 'u1',
          themePrimaryColor: ThemePrimaryColor.blue,
        ),
      ).called(1);
    },
  );
}
