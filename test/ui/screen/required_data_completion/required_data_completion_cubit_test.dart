import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/required_data_completion/cubit/required_data_completion_cubit.dart';
import 'package:betgrid/ui/screen/required_data_completion/cubit/required_data_completion_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  RequiredDataCompletionCubit createCubit() => RequiredDataCompletionCubit(
        authRepository,
        userRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
  });

  blocTest(
    'updateAvatar, '
    'should change avatarImgPath in state',
    build: () => createCubit(),
    act: (cubit) => cubit.updateAvatar('avatar/img/path'),
    expect: () => [
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.completed,
        avatarImgPath: 'avatar/img/path',
      ),
    ],
  );

  blocTest(
    'updateUsername, '
    'should change username in state',
    build: () => createCubit(),
    act: (cubit) => cubit.updateUsername('new username'),
    expect: () => [
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.completed,
        username: 'new username',
      ),
    ],
  );

  blocTest(
    'submit, '
    'username is empty, '
    'should emit state with status set to usernameIsEmpty',
    build: () => createCubit(),
    act: (cubit) async => await cubit.submit(
      themeMode: ThemeMode.system,
      themePrimaryColor: ThemePrimaryColor.pink,
    ),
    expect: () => [
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.usernameIsEmpty,
      ),
    ],
  );

  blocTest(
    'submit, '
    'logged user id is null, '
    'should emit state with status set to loggedUserDoesNotExist',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(null),
    act: (cubit) async {
      cubit.updateUsername('username');
      await cubit.submit(
        themeMode: ThemeMode.system,
        themePrimaryColor: ThemePrimaryColor.pink,
      );
    },
    expect: () => [
      const RequiredDataCompletionState(
        username: 'username',
      ),
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.loggedUserDoesNotExist,
        username: 'username',
      ),
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'submit, '
    'should call method from UserRepository to add user data',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockAddUser();
    },
    act: (cubit) async {
      cubit.updateUsername('username');
      cubit.updateAvatar('avatar/img/path');
      await cubit.submit(
        themeMode: ThemeMode.system,
        themePrimaryColor: ThemePrimaryColor.pink,
      );
    },
    expect: () => [
      const RequiredDataCompletionState(
        username: 'username',
      ),
      const RequiredDataCompletionState(
        username: 'username',
        avatarImgPath: 'avatar/img/path',
      ),
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.loading,
        username: 'username',
        avatarImgPath: 'avatar/img/path',
      ),
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.dataSaved,
        username: 'username',
        avatarImgPath: 'avatar/img/path',
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.addUser(
          userId: 'u1',
          username: 'username',
          avatarImgPath: 'avatar/img/path',
          themeMode: ThemeMode.system,
          themePrimaryColor: ThemePrimaryColor.pink,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'method from UserRepository to add user data throws UsernameAlreadyTaken '
    'exception, '
    'should emit state with status set to userIsAlreadyTaken',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockAddUser(
        throwable: const UserRepositoryExceptionUsernameAlreadyTaken(),
      );
    },
    act: (cubit) async {
      cubit.updateUsername('username');
      await cubit.submit(
        themeMode: ThemeMode.system,
        themePrimaryColor: ThemePrimaryColor.pink,
      );
    },
    expect: () => [
      const RequiredDataCompletionState(
        username: 'username',
      ),
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.loading,
        username: 'username',
      ),
      const RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.usernameIsAlreadyTaken,
        username: 'username',
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => userRepository.addUser(
          userId: 'u1',
          username: 'username',
          avatarImgPath: null,
          themeMode: ThemeMode.system,
          themePrimaryColor: ThemePrimaryColor.pink,
        ),
      ).called(1);
    },
  );
}
