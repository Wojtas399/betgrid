import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/home/cubit/home_cubit.dart';
import 'package:betgrid/ui/screen/home/cubit/home_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  HomeCubit createCubit() => HomeCubit(
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
      const String loggedUserId = 'u1';
      final User loggedUser = const UserCreator(
        id: loggedUserId,
        username: 'username',
        avatarUrl: 'avatar/url',
      ).createEntity();

      tearDown(() {
        verify(() => authRepository.loggedUserId$).called(1);
      });

      blocTest(
        'should emit state with loggedUserDoesNotExist status if logged user '
        'id is null',
        setUp: () => authRepository.mockGetLoggedUserId(null),
        build: () => createCubit(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(
            status: HomeStateStatus.loggedUserDoesNotExist,
          )
        ],
      );

      blocTest(
        'should emit state with loggedUserDataNotCompleted status if logged '
        'user does not have personal data',
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(user: null);
        },
        build: () => createCubit(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(
            status: HomeStateStatus.loggedUserDataNotCompleted,
          )
        ],
        verify: (_) => verify(
          () => userRepository.getUserById(userId: loggedUserId),
        ).called(1),
      );

      blocTest(
        'should emit state with username, avatarUrl and status set as '
        'completed if logged user has personal data',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          HomeState(
            status: HomeStateStatus.completed,
            username: loggedUser.username,
            avatarUrl: loggedUser.avatarUrl,
          ),
        ],
        verify: (_) => verify(
          () => userRepository.getUserById(userId: loggedUserId),
        ).called(1),
      );
    },
  );
}
