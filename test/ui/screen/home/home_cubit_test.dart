import 'package:betgrid/ui/screen/home/cubit/home_cubit.dart';
import 'package:betgrid/ui/screen/home/cubit/home_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/user_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final grandPrixRepository = MockGrandPrixRepository();

  HomeCubit createCubit() => HomeCubit(
        authRepository,
        userRepository,
        grandPrixBetRepository,
        grandPrixRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
    reset(grandPrixBetRepository);
    reset(grandPrixRepository);
  });

  blocTest(
    'initialize, '
    'logged user id is null, '
    'should emit state with loggedUserDoesNotExist status',
    setUp: () => authRepository.mockGetLoggedUserId(null),
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.loggedUserDoesNotExist,
      )
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'logged user data does not exist, '
    'should emit state with loggedUserDataNotCompleted status',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(user: null);
    },
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.loggedUserDataNotCompleted,
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user has bets already, '
    'should emit state with username, avatarUrl and status set as completed',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
        ),
      );
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: [
          createGrandPrixBet(id: 'gpb1'),
          createGrandPrixBet(id: 'gpb2'),
        ],
      );
    },
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.completed,
        username: 'username',
        avatarUrl: 'avatar/url',
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
          playerId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'list of logged user bets is null and list of all grand prixes is null, '
    'should emit state with username, avatarUrl and status set as completed',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
        ),
      );
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: null,
      );
      grandPrixRepository.mockGetAllGrandPrixes(null);
    },
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.completed,
        username: 'username',
        avatarUrl: 'avatar/url',
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
          playerId: 'u1',
        ),
      ).called(1);
      verify(() => grandPrixRepository.getAllGrandPrixes()).called(1);
    },
  );

  blocTest(
    'initialize, '
    'list of logged user bets is null and list of all grand prixes is empty, '
    'should emit state with username, avatarUrl and status set as completed',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
        ),
      );
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: null,
      );
      grandPrixRepository.mockGetAllGrandPrixes([]);
    },
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.completed,
        username: 'username',
        avatarUrl: 'avatar/url',
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
          playerId: 'u1',
        ),
      ).called(1);
      verify(() => grandPrixRepository.getAllGrandPrixes()).called(1);
    },
  );

  blocTest(
    'initialize, '
    'list of logged user bets is empty and list of all grand prixes is null, '
    'should emit state with username, avatarUrl and status set as completed',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
        ),
      );
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: [],
      );
      grandPrixRepository.mockGetAllGrandPrixes(null);
    },
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.completed,
        username: 'username',
        avatarUrl: 'avatar/url',
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
          playerId: 'u1',
        ),
      ).called(1);
      verify(() => grandPrixRepository.getAllGrandPrixes()).called(1);
    },
  );

  blocTest(
    'initialize, '
    'list of logged user bets is empty and list of all grand prixes is empty, '
    'should emit state with username, avatarUrl and status set as completed',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
        ),
      );
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: [],
      );
      grandPrixRepository.mockGetAllGrandPrixes([]);
    },
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.completed,
        username: 'username',
        avatarUrl: 'avatar/url',
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
          playerId: 'u1',
        ),
      ).called(1);
      verify(() => grandPrixRepository.getAllGrandPrixes()).called(1);
    },
  );

  blocTest(
    'initialize, '
    'should create default bets for each grand prix and should emit state with '
    'username, avatarUrl and status set as completed',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          username: 'username',
          avatarUrl: 'avatar/url',
        ),
      );
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: null,
      );
      grandPrixRepository.mockGetAllGrandPrixes([
        createGrandPrix(id: 'gp1'),
        createGrandPrix(id: 'gp2'),
        createGrandPrix(id: 'gp3'),
      ]);
      grandPrixBetRepository.mockAddGrandPrixBets();
    },
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const HomeState(
        status: HomeStateStatus.completed,
        username: 'username',
        avatarUrl: 'avatar/url',
      )
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBetsForPlayer(
          playerId: 'u1',
        ),
      ).called(1);
      verify(() => grandPrixRepository.getAllGrandPrixes()).called(1);
      verify(
        () => grandPrixBetRepository.addGrandPrixBets(
          playerId: 'u1',
          grandPrixBets: [
            createGrandPrixBet(playerId: 'u1', grandPrixId: 'gp1'),
            createGrandPrixBet(playerId: 'u1', grandPrixId: 'gp2'),
            createGrandPrixBet(playerId: 'u1', grandPrixId: 'gp3'),
          ],
        ),
      ).called(1);
    },
  );
}
