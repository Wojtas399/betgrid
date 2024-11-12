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

  group(
    'submit, ',
    () {
      const ThemeMode themeMode = ThemeMode.system;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      const String loggedUserId = 'u1';
      const String username = 'username';
      const String avatarPath = 'avatar/img/path';
      RequiredDataCompletionState? state;

      blocTest(
        'should emit state with status set to usernameIsEmpty if username is '
        'empty',
        build: () => createCubit(),
        act: (cubit) async => await cubit.submit(
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
        expect: () => [
          const RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsEmpty,
          ),
        ],
      );

      blocTest(
        'should finish method call if logged user id is null',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(null),
        seed: () => const RequiredDataCompletionState(
          username: username,
        ),
        act: (cubit) async => await cubit.submit(
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
        expect: () => [],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
      );

      blocTest(
        'should call method from UserRepository to add user data',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockAddUser();
        },
        seed: () => state = const RequiredDataCompletionState(
          username: username,
          avatarImgPath: avatarPath,
        ),
        act: (cubit) async => await cubit.submit(
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
        expect: () => [
          state = state?.copyWith(
            status: RequiredDataCompletionStateStatus.loading,
          ),
          state = state?.copyWith(
            status: RequiredDataCompletionStateStatus.dataSaved,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.addUser(
              userId: loggedUserId,
              username: username,
              avatarImgPath: avatarPath,
              themeMode: themeMode,
              themePrimaryColor: themePrimaryColor,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with status set to userIsAlreadyTaken if method '
        'from UserRepository to add user data throws UsernameAlreadyTaken '
        'exception',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockAddUser(
            throwable: const UserRepositoryExceptionUsernameAlreadyTaken(),
          );
        },
        seed: () => state = const RequiredDataCompletionState(
          username: username,
        ),
        act: (cubit) async => await cubit.submit(
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        ),
        expect: () => [
          state = state?.copyWith(
            status: RequiredDataCompletionStateStatus.loading,
          ),
          state = state?.copyWith(
            status: RequiredDataCompletionStateStatus.usernameIsAlreadyTaken,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.addUser(
              userId: loggedUserId,
              username: username,
              avatarImgPath: null,
              themeMode: themeMode,
              themePrimaryColor: themePrimaryColor,
            ),
          ).called(1);
        },
      );
    },
  );
}
