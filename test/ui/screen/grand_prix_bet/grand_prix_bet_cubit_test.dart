import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_cubit.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final grandPrixRepository = MockGrandPrixRepository();
  final playerRepository = MockPlayerRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  final driverRepository = MockDriverRepository();

  GrandPrixBetCubit createCubit() => GrandPrixBetCubit(
        authRepository,
        grandPrixRepository,
        playerRepository,
        grandPrixBetRepository,
        grandPrixResultsRepository,
        grandPrixBetPointsRepository,
        driverRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(grandPrixRepository);
    reset(playerRepository);
    reset(grandPrixBetRepository);
    reset(grandPrixResultsRepository);
    reset(grandPrixBetPointsRepository);
    reset(driverRepository);
  });

  blocTest(
    'initialize, '
    'player is logged user, '
    'should load player username, grand prix name, results, bets and bets points, '
    'allDrivers and should set isPlayerIdSameAsLoggedUserId param as true',
    setUp: () {
      authRepository.mockGetLoggedUserId('p1');
      playerRepository.mockGetPlayerById(
        player: createPlayer(username: 'username'),
      );
      grandPrixRepository.mockGetGrandPrixById(
        createGrandPrix(name: 'grand prix'),
      );
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixIdAndPlayerId(
        grandPrixBet: createGrandPrixBet(id: 'gpb1'),
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: createGrandPrixResults(id: 'gpr1'),
      );
      grandPrixBetPointsRepository.mockGetPointsForPlayerByGrandPrixId(
        grandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp1'),
      );
      driverRepository.mockGetAllDrivers(
        allDrivers: [
          createDriver(id: 'd1'),
          createDriver(id: 'd2'),
          createDriver(id: 'd3'),
        ],
      );
    },
    build: () => createCubit(),
    act: (cubit) => cubit.initialize(
      playerId: 'p1',
      grandPrixId: 'gp1',
    ),
    expect: () => [
      GrandPrixBetState(
        status: GrandPrixBetStateStatus.completed,
        playerUsername: 'username',
        grandPrixName: 'grand prix',
        isPlayerIdSameAsLoggedUserId: true,
        grandPrixBet: createGrandPrixBet(id: 'gpb1'),
        grandPrixResults: createGrandPrixResults(id: 'gpr1'),
        grandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp1'),
        allDrivers: [
          createDriver(id: 'd1'),
          createDriver(id: 'd2'),
          createDriver(id: 'd3'),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => playerRepository.getPlayerById(playerId: 'p1')).called(1);
      verify(
        () => grandPrixRepository.getGrandPrixById(
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixIdAndPlayerId(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixResultsRepository.getGrandPrixResultsForGrandPrix(
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(driverRepository.getAllDrivers).called(1);
    },
  );

  blocTest(
    'initialize, '
    'player is not logged user, '
    'should load player username, grand prix name, results, bets and bets points, '
    'allDrivers and should set isPlayerIdSameAsLoggedUserId param as false',
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      playerRepository.mockGetPlayerById(
        player: createPlayer(username: 'username'),
      );
      grandPrixRepository.mockGetGrandPrixById(
        createGrandPrix(name: 'grand prix'),
      );
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixIdAndPlayerId(
        grandPrixBet: createGrandPrixBet(id: 'gpb1'),
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: createGrandPrixResults(id: 'gpr1'),
      );
      grandPrixBetPointsRepository.mockGetPointsForPlayerByGrandPrixId(
        grandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp1'),
      );
      driverRepository.mockGetAllDrivers(
        allDrivers: [
          createDriver(id: 'd1'),
          createDriver(id: 'd2'),
          createDriver(id: 'd3'),
        ],
      );
    },
    build: () => createCubit(),
    act: (cubit) => cubit.initialize(
      playerId: 'p1',
      grandPrixId: 'gp1',
    ),
    expect: () => [
      GrandPrixBetState(
        status: GrandPrixBetStateStatus.completed,
        playerUsername: 'username',
        grandPrixName: 'grand prix',
        isPlayerIdSameAsLoggedUserId: false,
        grandPrixBet: createGrandPrixBet(id: 'gpb1'),
        grandPrixResults: createGrandPrixResults(id: 'gpr1'),
        grandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp1'),
        allDrivers: [
          createDriver(id: 'd1'),
          createDriver(id: 'd2'),
          createDriver(id: 'd3'),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => playerRepository.getPlayerById(playerId: 'p1')).called(1);
      verify(
        () => grandPrixRepository.getGrandPrixById(
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixIdAndPlayerId(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixResultsRepository.getGrandPrixResultsForGrandPrix(
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(driverRepository.getAllDrivers).called(1);
    },
  );
}
