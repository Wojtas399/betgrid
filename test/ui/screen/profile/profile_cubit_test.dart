import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/profile/cubit/profile_cubit.dart';
import 'package:betgrid/ui/screen/profile/cubit/profile_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  ProfileCubit createCubit() => ProfileCubit(
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
    'should emit state with status set as loggedUserDoesNotExist',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const ProfileState(
        status: ProfileStateStatus.loggedUserDoesNotExist,
      ),
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'should load and emit logged user data',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: UserCreator(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
          themeMode: UserCreatorThemeMode.dark,
          themePrimaryColor: UserCreatorThemePrimaryColor.brown,
        ).createEntity(),
      );
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const ProfileState(
        status: ProfileStateStatus.completed,
        username: 'username',
        avatarUrl: 'avatar/url',
        themeMode: ThemeMode.dark,
        themePrimaryColor: ThemePrimaryColor.brown,
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
    },
  );

  blocTest(
    'updateAvatar, '
    'logged user id is null, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) async => await cubit.updateAvatar('avatar/img/path'),
    expect: () => [],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'updateAvatar, '
    'should call method from UserRepository to update user avatar',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockUpdateUserAvatar();
    },
    act: (cubit) async => await cubit.updateAvatar('avatar/img/path'),
    expect: () => [
      const ProfileState(
        status: ProfileStateStatus.loading,
      ),
      const ProfileState(
        status: ProfileStateStatus.completed,
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserAvatar(
          userId: 'u1',
          avatarImgPath: 'avatar/img/path',
        ),
      ).called(1);
    },
  );

  blocTest(
    'updateUsername, '
    'new username is empty, '
    'should emit state with status set to newUsernameIsEmpty',
    build: () => createCubit(),
    act: (cubit) async => await cubit.updateUsername(''),
    expect: () => [
      const ProfileState(
        status: ProfileStateStatus.newUsernameIsEmpty,
      ),
    ],
  );

  blocTest(
    'updateUsername, '
    'logged user id is null, '
    'should finish method call',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) async => await cubit.updateUsername('new username'),
    expect: () => [],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'updateUsername, '
    'should call method from UserRepository to update user data with new username',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockUpdateUserData();
    },
    act: (cubit) async => await cubit.updateUsername('new username'),
    expect: () => [
      const ProfileState(
        status: ProfileStateStatus.loading,
      ),
      const ProfileState(
        status: ProfileStateStatus.usernameUpdated,
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserData(
          userId: 'u1',
          username: 'new username',
        ),
      ).called(1);
    },
  );

  blocTest(
    'updateUsername, '
    'method from UserRepository to update user data throws UsernameAlreadyTaken '
    'exception, '
    'should emit state with status set to newUsernameIsAlreadyTaken',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockUpdateUserData(
        throwable: const UserRepositoryExceptionUsernameAlreadyTaken(),
      );
    },
    act: (cubit) async => await cubit.updateUsername('new username'),
    expect: () => [
      const ProfileState(
        status: ProfileStateStatus.loading,
      ),
      const ProfileState(
        status: ProfileStateStatus.newUsernameIsAlreadyTaken,
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserData(
          userId: 'u1',
          username: 'new username',
        ),
      ).called(1);
    },
  );
}
