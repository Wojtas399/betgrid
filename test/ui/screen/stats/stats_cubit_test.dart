import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_cubit.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/ui/mock_create_players_podium_stats.dart';
import '../../../mock/ui/mock_create_points_for_driver_stats.dart';
import '../../../mock/ui/mock_create_points_history_stats.dart';
import '../../../mock/use_case/mock_get_details_for_all_drivers_from_season_use_case.dart';

void main() {
  final getDetailsOfAllDriversFromSeasonUseCase =
      MockGetDetailsOfAllDriversFromSeasonUseCase();
  final createPlayersPodiumStats = MockCreatePlayersPodiumStats();
  final createPointsHistoryStats = MockCreatePointsHistoryStats();
  final createPointsForDriverStats = MockCreatePointsForDriverStats();

  StatsCubit createCubit() => StatsCubit(
        getDetailsOfAllDriversFromSeasonUseCase,
        createPlayersPodiumStats,
        createPointsHistoryStats,
        createPointsForDriverStats,
      );

  tearDown(() {
    reset(getDetailsOfAllDriversFromSeasonUseCase);
    reset(createPlayersPodiumStats);
    reset(createPointsHistoryStats);
    reset(createPointsForDriverStats);
  });

  group(
    'initialize, ',
    () {
      const int season = 2024;
      final PlayersPodium playersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: const PlayerCreator(id: 'p3').create(),
          points: 33,
        ),
      );
      const PointsHistory pointsHistory = PointsHistory(
        players: [],
        grandPrixes: [],
      );
      final List<DriverDetails> allDrivers = [
        const DriverDetailsCreator(
          seasonDriverId: 'd1',
          teamName: 'Ferrari',
        ).create(),
        const DriverDetailsCreator(
          seasonDriverId: 'd2',
          teamName: 'Red Bull Racing',
        ).create(),
        const DriverDetailsCreator(
          seasonDriverId: 'd3',
          teamName: 'Alpine',
        ).create(),
      ];

      tearDown(() {
        verify(createPlayersPodiumStats.call).called(1);
        verify(createPointsHistoryStats.call).called(1);
        verify(
          () => getDetailsOfAllDriversFromSeasonUseCase.call(season),
        ).called(1);
      });

      blocTest(
        'should emit noData status if players podium and points history data '
        'are null and list of all drivers is empty',
        build: () => createCubit(),
        setUp: () {
          createPlayersPodiumStats.mock();
          createPointsHistoryStats.mock();
          getDetailsOfAllDriversFromSeasonUseCase.mock(
            expectedDetailsOfAllDriversFromSeason: [],
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => const [
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
          getDetailsOfAllDriversFromSeasonUseCase.mock(
            expectedDetailsOfAllDriversFromSeason: allDrivers,
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          StatsState(
            status: StatsStateStatus.completed,
            playersPodium: playersPodium,
            pointsHistory: pointsHistory,
            pointsByDriver: [],
            detailsOfDriversFromSeason: [
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
        player: const PlayerCreator(id: 'p1').create(),
        points: 22.22,
      );

      blocTest(
        'should emit state with points for driver_personal_data chart data',
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
