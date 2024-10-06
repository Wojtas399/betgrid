import 'package:betgrid/model/driver.dart';
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

  group(
    'initialize, ',
    () {
      final PlayersPodium playersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: PlayerCreator(id: 'p3').createEntity(),
          points: 33,
        ),
      );
      const PointsHistory pointsHistory = PointsHistory(
        players: [],
        grandPrixes: [],
      );
      final List<Driver> allDrivers = [
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
      ];

      tearDown(() {
        verify(createPlayersPodiumStats.call).called(1);
        verify(createPointsHistoryStats.call).called(1);
        verify(driverRepository.getAllDrivers).called(1);
      });

      blocTest(
        'should emit noData status if players podium and points history data '
        'are null and list of all drivers is empty',
        build: () => createCubit(),
        setUp: () {
          createPlayersPodiumStats.mock();
          createPointsHistoryStats.mock();
          driverRepository.mockGetAllDrivers(allDrivers: []);
        },
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          StatsState(
            status: StatsStateStatus.noData,
          ),
        ],
      );

      blocTest(
        'should emit state with data of players podium chart and points '
        'history chart and list of all drivers sorted by team',
        build: () => createCubit(),
        setUp: () {
          createPlayersPodiumStats.mock(
            playersPodium: playersPodium,
          );
          createPointsHistoryStats.mock(
            pointsHistory: pointsHistory,
          );
          driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
        },
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          StatsState(
            status: StatsStateStatus.completed,
            playersPodium: playersPodium,
            pointsHistory: pointsHistory,
            pointsByDriver: [],
            allDrivers: [
              allDrivers.last,
              allDrivers.first,
              allDrivers[1],
            ],
          ),
        ],
      );
    },
  );

  group(
    'onDriverChanged, ',
    () {
      final PointsByDriverPlayerPoints playerPointsForDriver =
          PointsByDriverPlayerPoints(
        player: PlayerCreator(id: 'p1').createEntity(),
        points: 22.22,
      );

      blocTest(
        'should emit state with points for driver chart data',
        build: () => createCubit(),
        setUp: () => createPointsForDriverStats.mock(
          playersPointsForDriver: [playerPointsForDriver],
        ),
        act: (cubit) async => await cubit.onDriverChanged('d1'),
        expect: () => [
          const StatsState(
            status: StatsStateStatus.pointsForDriverLoading,
          ),
          StatsState(
            status: StatsStateStatus.completed,
            pointsByDriver: [playerPointsForDriver],
          ),
        ],
        verify: (_) => verify(
          () => createPointsForDriverStats.call(driverId: 'd1'),
        ).called(1),
      );
    },
  );
}
