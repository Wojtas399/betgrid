import 'package:betgrid/ui/screen/stats/cubit/stats_cubit.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/ui/mock_create_players_podium_stats.dart';
import '../../../mock/ui/mock_create_points_for_driver_stats.dart';
import '../../../mock/ui/mock_create_points_history_stats.dart';

void main() {
  final driverRepository = MockDriverRepository();
  final createPlayersPodiumStats = MockCreatePlayersPodiumStats();
  final createPointsHistoryStats = MockCreatePointsHistoryStats();
  final createPointsForDriverStats = MockCreatePointsForDriverStats();

  StatsCubit createCubit() => StatsCubit(
        driverRepository,
        createPlayersPodiumStats,
        createPointsHistoryStats,
        createPointsForDriverStats,
      );

  tearDown(() {
    reset(driverRepository);
    reset(createPlayersPodiumStats);
    reset(createPointsHistoryStats);
    reset(createPointsForDriverStats);
  });

  blocTest(
    'initialize, '
    'should emit state with data of players podium chart and points history '
    'chart and list of all drivers',
    build: () => createCubit(),
    setUp: () {
      createPlayersPodiumStats.mock(
        playersPodium: PlayersPodium(
          p1Player: PlayersPodiumPlayer(
            player: PlayerCreator(id: 'p3').createEntity(),
            points: 33,
          ),
        ),
      );
      createPointsHistoryStats.mock(
        pointsHistory: const PointsHistory(
          players: [],
          grandPrixes: [],
        ),
      );
      driverRepository.mockGetAllDrivers(allDrivers: [
        DriverCreator(
          id: 'd1',
          team: DriverCreatorTeam.ferrari,
        ).createEntity(),
        DriverCreator(
          id: 'd2',
          team: DriverCreatorTeam.redBullRacing,
        ).createEntity(),
        DriverCreator(
          id: 'd3',
          team: DriverCreatorTeam.alpine,
        ).createEntity(),
      ]);
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      StatsState(
        status: StatsStateStatus.completed,
        playersPodium: PlayersPodium(
          p1Player: PlayersPodiumPlayer(
            player: PlayerCreator(id: 'p3').createEntity(),
            points: 33,
          ),
        ),
        pointsHistory: const PointsHistory(
          players: [],
          grandPrixes: [],
        ),
        pointsByDriver: [],
        allDrivers: [
          DriverCreator(
            id: 'd3',
            team: DriverCreatorTeam.alpine,
          ).createEntity(),
          DriverCreator(
            id: 'd1',
            team: DriverCreatorTeam.ferrari,
          ).createEntity(),
          DriverCreator(
            id: 'd2',
            team: DriverCreatorTeam.redBullRacing,
          ).createEntity(),
        ],
      ),
    ],
    verify: (_) {
      verify(createPlayersPodiumStats.call).called(1);
      verify(createPointsHistoryStats.call).called(1);
      verify(() => driverRepository.getAllDrivers()).called(1);
    },
  );

  blocTest(
    'onDriverChanged, '
    'should emit state with points for driver chart data',
    build: () => createCubit(),
    setUp: () => createPointsForDriverStats.mock(
      playersPointsForDriver: [
        PointsByDriverPlayerPoints(
          player: PlayerCreator(id: 'p1').createEntity(),
          points: 22.22,
        ),
      ],
    ),
    act: (cubit) async => await cubit.onDriverChanged('d1'),
    expect: () => [
      const StatsState(
        status: StatsStateStatus.pointsForDriverLoading,
      ),
      StatsState(
        status: StatsStateStatus.completed,
        pointsByDriver: [
          PointsByDriverPlayerPoints(
            player: PlayerCreator(id: 'p1').createEntity(),
            points: 22.22,
          ),
        ],
      ),
    ],
    verify: (_) => verify(
      () => createPointsForDriverStats.call(driverId: 'd1'),
    ).called(1),
  );
}
