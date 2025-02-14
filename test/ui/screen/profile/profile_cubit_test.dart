import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/profile/cubit/profile_cubit.dart';
import 'package:betgrid/ui/screen/profile/cubit/profile_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_creator.dart';
import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  ProfileCubit createCubit() => ProfileCubit(authRepository, userRepository);

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
  });

  group('initialize, ', () {
    const String loggedUserId = 'u1';
    final User loggedUser =
        const UserCreator(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
          themeMode: UserCreatorThemeMode.dark,
          themePrimaryColor: UserCreatorThemePrimaryColor.brown,
        ).create();

    tearDown(() {
      verify(() => authRepository.loggedUserId$).called(1);
    });

    blocTest(
      'should do nothing if logged user id is null',
      build: () => createCubit(),
      setUp: () => authRepository.mockGetLoggedUserId(null),
      act: (cubit) => cubit.initialize(),
      expect: () => [],
    );

    blocTest(
      'should load and emit logged user data',
      build: () => createCubit(),
      setUp: () {
        authRepository.mockGetLoggedUserId(loggedUserId);
        userRepository.mockGetById(user: loggedUser);
      },
      act: (cubit) => cubit.initialize(),
      expect:
          () => [
            ProfileState(
              status: ProfileStateStatus.completed,
              username: loggedUser.username,
              avatarUrl: loggedUser.avatarUrl,
              themeMode: loggedUser.themeMode,
              themePrimaryColor: loggedUser.themePrimaryColor,
            ),
          ],
      verify:
          (_) => verify(() => userRepository.getById(loggedUserId)).called(1),
    );
  });

  group('updateAvatar, ', () {
    const String loggedUserId = 'u1';
    const String newAvatarImgPath = 'avatar/img/path';

    blocTest(
      'should do nothing if logged user id is null',
      build: () => createCubit(),
      setUp: () => authRepository.mockGetLoggedUserId(null),
      act: (cubit) async => await cubit.updateAvatar(newAvatarImgPath),
      expect: () => [],
      verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
    );

    blocTest(
      'should call method from UserRepository to update user avatar',
      build: () => createCubit(),
      setUp: () {
        authRepository.mockGetLoggedUserId(loggedUserId);
        userRepository.mockUpdateAvatar();
      },
      act: (cubit) async => await cubit.updateAvatar(newAvatarImgPath),
      expect:
          () => [
            const ProfileState(status: ProfileStateStatus.loading),
            const ProfileState(status: ProfileStateStatus.completed),
          ],
      verify: (_) {
        verify(() => authRepository.loggedUserId$).called(1);
        verify(
          () => userRepository.updateAvatar(
            userId: loggedUserId,
            avatarImgPath: newAvatarImgPath,
          ),
        ).called(1);
      },
    );
  });

  group('updateUsername, ', () {
    const String loggedUserId = 'u1';
    const String newUsername = 'new username';

    blocTest(
      'should do nothing if new username is empty',
      build: () => createCubit(),
      act: (cubit) async => await cubit.updateUsername(''),
      expect: () => [],
    );

    blocTest(
      'should finish method call if logged user id is null',
      build: () => createCubit(),
      setUp: () => authRepository.mockGetLoggedUserId(null),
      act: (cubit) async => await cubit.updateUsername(newUsername),
      expect: () => [],
      verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
    );

    blocTest(
      'should call method from UserRepository to update user data with '
      'new username',
      build: () => createCubit(),
      setUp: () {
        authRepository.mockGetLoggedUserId(loggedUserId);
        userRepository.mockUpdateData();
      },
      act: (cubit) async => await cubit.updateUsername(newUsername),
      expect:
          () => [
            const ProfileState(status: ProfileStateStatus.loading),
            const ProfileState(status: ProfileStateStatus.usernameUpdated),
          ],
      verify: (_) {
        verify(() => authRepository.loggedUserId$).called(1);
        verify(
          () => userRepository.updateData(
            userId: loggedUserId,
            username: newUsername,
          ),
        ).called(1);
      },
    );

    blocTest(
      'should emit state with status set to newUsernameIsAlreadyTaken if '
      'method from UserRepository to update user data throws '
      'UsernameAlreadyTaken exception',
      build: () => createCubit(),
      setUp: () {
        authRepository.mockGetLoggedUserId(loggedUserId);
        userRepository.mockUpdateData(
          throwable: const UserRepositoryExceptionUsernameAlreadyTaken(),
        );
      },
      act: (cubit) async => await cubit.updateUsername(newUsername),
      expect:
          () => [
            const ProfileState(status: ProfileStateStatus.loading),
            const ProfileState(
              status: ProfileStateStatus.newUsernameIsAlreadyTaken,
            ),
          ],
      verify: (_) {
        verify(() => authRepository.loggedUserId$).called(1);
        verify(
          () => userRepository.updateData(
            userId: loggedUserId,
            username: newUsername,
          ),
        ).called(1);
      },
    );
  });
}
