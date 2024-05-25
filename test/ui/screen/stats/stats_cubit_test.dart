import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_cubit.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/ui/mock_date_service.dart';
import '../../../mock/ui/mock_players_podium_maker.dart';
import '../../../mock/ui/mock_points_for_driver_maker.dart';
import '../../../mock/ui/mock_points_history_maker.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  final driverRepository = MockDriverRepository();
  final dateService = MockDateService();
  final playersPodiumMaker = MockPlayersPodiumMaker();
  final pointsHistoryMaker = MockPointsHistoryMaker();
  final pointsForDriverMaker = MockPointsForDriverMaker();

  StatsCubit createCubit() => StatsCubit(
        playerRepository,
        grandPrixRepository,
        grandPrixBetRepository,
        grandPrixResultsRepository,
        grandPrixBetPointsRepository,
        dateService,
        driverRepository,
        playersPodiumMaker,
        pointsHistoryMaker,
        pointsForDriverMaker,
      );

  void mockGetGrandPrixBetPointsForPlayerAndGrandPrix({
    required String playerId,
    required String grandPrixId,
    required GrandPrixBetPoints expectedGrandPrixBetPoints,
  }) {
    when(
      () => grandPrixBetPointsRepository
          .getGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: playerId,
        grandPrixId: grandPrixId,
      ),
    ).thenAnswer((_) => Stream.value(expectedGrandPrixBetPoints));
  }

  tearDown(() {
    reset(playerRepository);
    reset(grandPrixRepository);
    reset(grandPrixBetPointsRepository);
    reset(grandPrixResultsRepository);
    reset(grandPrixBetPointsRepository);
    reset(driverRepository);
    reset(dateService);
    reset(playersPodiumMaker);
    reset(pointsHistoryMaker);
    reset(pointsForDriverMaker);
  });

  blocTest(
    'initialize, '
    'list of all players is null, '
    'should emit state with status set to playersDontExist',
    build: () => createCubit(),
    setUp: () => playerRepository.mockGetAllPlayers(players: null),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const StatsState(
        status: StatsStateStatus.playersDontExist,
      ),
    ],
    verify: (_) => verify(() => playerRepository.getAllPlayers()).called(1),
  );

  blocTest(
    'initialize, '
    'list of all players is empty, '
    'should emit state with status set to playersDontExist',
    build: () => createCubit(),
    setUp: () => playerRepository.mockGetAllPlayers(players: []),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const StatsState(
        status: StatsStateStatus.playersDontExist,
      ),
    ],
    verify: (_) => verify(() => playerRepository.getAllPlayers()).called(1),
  );

  blocTest(
    'initialize, '
    'should emit state with data of players podium chart and points history '
    'chart and list of all drivers',
    build: () => createCubit(),
    setUp: () {
      playerRepository.mockGetAllPlayers(players: [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
      ]);
      grandPrixRepository.mockGetAllGrandPrixes([
        createGrandPrix(
          id: 'gp1',
          roundNumber: 2,
          startDate: DateTime(2024, 5, 22),
        ),
        createGrandPrix(
          id: 'gp2',
          roundNumber: 1,
          startDate: DateTime(2024, 5, 20),
        ),
        createGrandPrix(
          id: 'gp3',
          roundNumber: 3,
          startDate: DateTime(2024, 5, 23),
        ),
      ]);
      dateService.mockGetNow(
        now: DateTime(2024, 5, 22, 10, 30),
      );
      driverRepository.mockGetAllDrivers(allDrivers: [
        createDriver(id: 'd1', team: Team.ferrari),
        createDriver(id: 'd2', team: Team.redBullRacing),
        createDriver(id: 'd3', team: Team.alpine),
      ]);
      mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: 'p1',
        grandPrixId: 'gp1',
        expectedGrandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp1'),
      );
      mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: 'p1',
        grandPrixId: 'gp2',
        expectedGrandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp2'),
      );
      mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: 'p2',
        grandPrixId: 'gp1',
        expectedGrandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp3'),
      );
      mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: 'p2',
        grandPrixId: 'gp2',
        expectedGrandPrixBetPoints: createGrandPrixBetPoints(id: 'gpbp4'),
      );
      playersPodiumMaker.mockPrepareStats(
        playersPodium: PlayersPodium(
          p1Player: PlayersPodiumPlayer(
            player: createPlayer(id: 'p3'),
            points: 33,
          ),
        ),
      );
      pointsHistoryMaker.mockPrepareStats(
        pointsHistory: const PointsHistory(
          players: [],
          grandPrixes: [],
        ),
      );
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      StatsState(
        status: StatsStateStatus.completed,
        playersPodium: PlayersPodium(
          p1Player: PlayersPodiumPlayer(
            player: createPlayer(id: 'p3'),
            points: 33,
          ),
        ),
        pointsHistory: const PointsHistory(
          players: [],
          grandPrixes: [],
        ),
        pointsByDriver: [],
        allDrivers: [
          createDriver(id: 'd3', team: Team.alpine),
          createDriver(id: 'd1', team: Team.ferrari),
          createDriver(id: 'd2', team: Team.redBullRacing),
        ],
      ),
    ],
    verify: (_) {
      verify(() => playerRepository.getAllPlayers()).called(1);
      verify(() => grandPrixRepository.getAllGrandPrixes()).called(1);
      verify(() => dateService.getNow()).called(1);
      verify(() => driverRepository.getAllDrivers()).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: 'p1',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: 'p1',
          grandPrixId: 'gp2',
        ),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: 'p2',
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: 'p2',
          grandPrixId: 'gp2',
        ),
      ).called(1);
      verify(
        () => playersPodiumMaker.prepareStats(
          players: [
            createPlayer(id: 'p1'),
            createPlayer(id: 'p2'),
          ],
          grandPrixBetsPoints: [
            createGrandPrixBetPoints(id: 'gpbp1'),
            createGrandPrixBetPoints(id: 'gpbp2'),
            createGrandPrixBetPoints(id: 'gpbp3'),
            createGrandPrixBetPoints(id: 'gpbp4'),
          ],
        ),
      ).called(1);
      verify(
        () => pointsHistoryMaker.prepareStats(
          players: [
            createPlayer(id: 'p1'),
            createPlayer(id: 'p2'),
          ],
          finishedGrandPrixes: [
            createGrandPrix(
              id: 'gp1',
              roundNumber: 2,
              startDate: DateTime(2024, 5, 22),
            ),
            createGrandPrix(
              id: 'gp2',
              roundNumber: 1,
              startDate: DateTime(2024, 5, 20),
            ),
          ],
          grandPrixBetsPoints: [
            createGrandPrixBetPoints(id: 'gpbp1'),
            createGrandPrixBetPoints(id: 'gpbp2'),
            createGrandPrixBetPoints(id: 'gpbp3'),
            createGrandPrixBetPoints(id: 'gpbp4'),
          ],
        ),
      ).called(1);
    },
  );

  blocTest(
    'onDriverChanged, '
    'list of all players is null, '
    'should emit state with status set to playersDontExist',
    build: () => createCubit(),
    setUp: () => playerRepository.mockGetAllPlayers(players: null),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const StatsState(
        status: StatsStateStatus.playersDontExist,
      ),
    ],
    verify: (_) => verify(() => playerRepository.getAllPlayers()).called(1),
  );

  blocTest(
    'onDriverChanged, '
    'list of all players is empty, '
    'should emit state with status set to playersDontExist',
    build: () => createCubit(),
    setUp: () => playerRepository.mockGetAllPlayers(players: []),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const StatsState(
        status: StatsStateStatus.playersDontExist,
      ),
    ],
    verify: (_) => verify(() => playerRepository.getAllPlayers()).called(1),
  );

  blocTest(
    'onDriverChanged, '
    'should emit state with points for driver chart data',
    build: () => createCubit(),
    setUp: () {
      playerRepository.mockGetAllPlayers(players: [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
      ]);
      grandPrixRepository.mockGetAllGrandPrixes([
        createGrandPrix(
          id: 'gp1',
          roundNumber: 2,
          startDate: DateTime(2024, 5, 22),
        ),
        createGrandPrix(
          id: 'gp2',
          roundNumber: 1,
          startDate: DateTime(2024, 5, 20),
        ),
        createGrandPrix(
          id: 'gp3',
          roundNumber: 3,
          startDate: DateTime(2024, 5, 23),
        ),
      ]);
      dateService.mockGetNow(
        now: DateTime(2024, 5, 22, 10, 30),
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrixes(
        grandPrixesResults: [
          createGrandPrixResults(id: 'gpr1', grandPrixId: 'gp1'),
          createGrandPrixResults(id: 'gpr2', grandPrixId: 'gp2')
        ],
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixBetPoints: [
          createGrandPrixBetPoints(id: 'gpbp1'),
          createGrandPrixBetPoints(id: 'gpbp2'),
          createGrandPrixBetPoints(id: 'gpbp3'),
          createGrandPrixBetPoints(id: 'gpbp4'),
        ],
      );
      grandPrixBetRepository.mockGetGrandPrixBetsForPlayersAndGrandPrixes(
        grandPrixBets: [
          createGrandPrixBet(id: 'gpb1'),
          createGrandPrixBet(id: 'gpb2'),
          createGrandPrixBet(id: 'gpb3'),
          createGrandPrixBet(id: 'gpb4'),
        ],
      );
      pointsForDriverMaker.mockPrepareStats(
        playersPointsForDriver: [
          PointsByDriverPlayerPoints(
            player: createPlayer(id: 'p1'),
            points: 22.22,
          ),
        ],
      );
    },
    act: (cubit) async => await cubit.onDriverChanged('d1'),
    expect: () => [
      const StatsState(
        status: StatsStateStatus.pointsForDriverLoading,
      ),
      StatsState(
        status: StatsStateStatus.completed,
        pointsByDriver: [
          PointsByDriverPlayerPoints(
            player: createPlayer(id: 'p1'),
            points: 22.22,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(playerRepository.getAllPlayers).called(1);
      verify(grandPrixRepository.getAllGrandPrixes).called(1);
      verify(dateService.getNow).called(1);
      verify(
        () => grandPrixResultsRepository.getGrandPrixResultsForGrandPrixes(
          idsOfGrandPrixes: ['gp1', 'gp2'],
        ),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: ['p1', 'p2'],
          idsOfGrandPrixes: ['gp1', 'gp2'],
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetsForPlayersAndGrandPrixes(
          idsOfPlayers: ['p1', 'p2'],
          idsOfGrandPrixes: ['gp1', 'gp2'],
        ),
      ).called(1);
      verify(
        () => pointsForDriverMaker.prepareStats(
          driverId: 'd1',
          players: [
            createPlayer(id: 'p1'),
            createPlayer(id: 'p2'),
          ],
          grandPrixesIds: ['gp1', 'gp2'],
          grandPrixesResults: [
            createGrandPrixResults(id: 'gpr1', grandPrixId: 'gp1'),
            createGrandPrixResults(id: 'gpr2', grandPrixId: 'gp2'),
          ],
          grandPrixesBetPoints: [
            createGrandPrixBetPoints(id: 'gpbp1'),
            createGrandPrixBetPoints(id: 'gpbp2'),
            createGrandPrixBetPoints(id: 'gpbp3'),
            createGrandPrixBetPoints(id: 'gpbp4'),
          ],
          grandPrixesBets: [
            createGrandPrixBet(id: 'gpb1'),
            createGrandPrixBet(id: 'gpb2'),
            createGrandPrixBet(id: 'gpb3'),
            createGrandPrixBet(id: 'gpb4'),
          ],
        ),
      ).called(1);
    },
  );
}
