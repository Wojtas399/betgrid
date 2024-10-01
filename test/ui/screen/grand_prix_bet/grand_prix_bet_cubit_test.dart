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
        GrandPrixCreator(name: 'grand prix').createEntity(),
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: GrandPrixBetCreator(id: 'gpb1').createEntity(),
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: GrandPrixResultsCreator(id: 'gpr1').createEntity(),
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        grandPrixBetPoints:
            GrandPrixBetPointsCreator(id: 'gpbp1').createEntity(),
      );
      driverRepository.mockGetAllDrivers(
        allDrivers: [
          DriverCreator(id: 'd1').createEntity(),
          DriverCreator(id: 'd2').createEntity(),
          DriverCreator(id: 'd3').createEntity(),
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
        grandPrixBet: GrandPrixBetCreator(id: 'gpb1').createEntity(),
        grandPrixResults: GrandPrixResultsCreator(id: 'gpr1').createEntity(),
        grandPrixBetPoints:
            GrandPrixBetPointsCreator(id: 'gpbp1').createEntity(),
        allDrivers: [
          DriverCreator(id: 'd1').createEntity(),
          DriverCreator(id: 'd2').createEntity(),
          DriverCreator(id: 'd3').createEntity(),
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
        () => grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
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
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
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
        GrandPrixCreator(name: 'grand prix').createEntity(),
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: GrandPrixBetCreator(id: 'gpb1').createEntity(),
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: GrandPrixResultsCreator(id: 'gpr1').createEntity(),
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        grandPrixBetPoints:
            GrandPrixBetPointsCreator(id: 'gpbp1').createEntity(),
      );
      driverRepository.mockGetAllDrivers(
        allDrivers: [
          DriverCreator(id: 'd1').createEntity(),
          DriverCreator(id: 'd2').createEntity(),
          DriverCreator(id: 'd3').createEntity(),
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
        grandPrixBet: GrandPrixBetCreator(id: 'gpb1').createEntity(),
        grandPrixResults: GrandPrixResultsCreator(id: 'gpr1').createEntity(),
        grandPrixBetPoints:
            GrandPrixBetPointsCreator(id: 'gpbp1').createEntity(),
        allDrivers: [
          DriverCreator(id: 'd1').createEntity(),
          DriverCreator(id: 'd2').createEntity(),
          DriverCreator(id: 'd3').createEntity(),
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
        () => grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
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
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(driverRepository.getAllDrivers).called(1);
    },
  );
}
