import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_cubit.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_model/best_points.dart';
import 'package:betgrid/ui/screen/stats/stats_model/player_points.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_for_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/ui/mock_create_best_points.dart';
import '../../../mock/ui/mock_create_logged_user_points_for_drivers_stats.dart';
import '../../../mock/ui/mock_create_players_podium_stats.dart';
import '../../../mock/ui/mock_create_points_for_driver_stats.dart';
import '../../../mock/ui/mock_create_points_history_stats.dart';
import '../../../mock/ui/mock_season_cubit.dart';
import '../../../mock/use_case/mock_get_details_for_all_drivers_from_season_use_case.dart';

void main() {
  final getDetailsOfAllDriversFromSeasonUseCase =
      MockGetDetailsOfAllDriversFromSeasonUseCase();
  final createPlayersPodiumStats = MockCreatePlayersPodiumStats();
  final createPointsHistoryStats = MockCreatePointsHistoryStats();
  final createPointsForDriverStats = MockCreatePointsForDriverStats();
  final createBestPoints = MockCreateBestPoints();
  final createLoggedUserPointsForDriversStats =
      MockCreateLoggedUserPointsForDriversStats();
  final seasonCubit = MockSeasonCubit();

  StatsCubit createCubit() => StatsCubit(
        getDetailsOfAllDriversFromSeasonUseCase,
        createPlayersPodiumStats,
        createPointsHistoryStats,
        createPointsForDriverStats,
        createBestPoints,
        createLoggedUserPointsForDriversStats,
        seasonCubit,
      );

  tearDown(() {
    reset(getDetailsOfAllDriversFromSeasonUseCase);
    reset(createPlayersPodiumStats);
    reset(createPointsHistoryStats);
    reset(createPointsForDriverStats);
    reset(createBestPoints);
    reset(createLoggedUserPointsForDriversStats);
    reset(seasonCubit);
  });

  group(
    'initialize, ',
    () {
      const int currentSeason = 2024;
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
      const BestPoints bestPoints = BestPoints(
        bestGpPoints: BestPointsForGp(
          points: 11,
          playerName: 'p1',
          grandPrixName: 'gp1',
        ),
        bestQualiPoints: BestPointsForGp(
          points: 22,
          playerName: 'p2',
          grandPrixName: 'gp2',
        ),
        bestRacePoints: BestPointsForGp(
          points: 33,
          playerName: 'p3',
          grandPrixName: 'gp3',
        ),
        bestDriverPoints: BestPointsForDriver(
          points: 44,
          playerName: 'p4',
          driverName: 'name',
          driverSurname: 'surname',
        ),
      );

      setUp(() {
        seasonCubit.mockState(expectedState: currentSeason);
      });

      tearDown(() {
        verify(
          () => createPlayersPodiumStats.call(
            season: currentSeason,
          ),
        ).called(1);
        verify(
          () => createPointsHistoryStats.call(
            statsType: StatsType.grouped,
            season: currentSeason,
          ),
        ).called(1);
        verify(
          () => getDetailsOfAllDriversFromSeasonUseCase.call(currentSeason),
        ).called(1);
        verify(
          () => createBestPoints.call(
            statsType: StatsType.grouped,
            season: currentSeason,
          ),
        ).called(1);
      });

      blocTest(
        'should emit state with all grouped stats data without points for '
        'driver',
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
          createBestPoints.mock(
            expectedBestPoints: bestPoints,
          );
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          StatsState(
            status: StatsStateStatus.completed,
            stats: GroupedStats(
              playersPodium: playersPodium,
              pointsHistory: pointsHistory,
              playersPointsForDriver: [],
              detailsOfDriversFromSeason: [
                allDrivers.last,
                allDrivers.first,
                allDrivers[1],
              ],
              bestPoints: bestPoints,
            ),
          ),
        ],
      );
    },
  );

  group(
    'onStatsTypeChanged, ',
    () {
      const int currentSeason = 2024;
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
      const BestPoints bestPoints = BestPoints(
        bestGpPoints: BestPointsForGp(
          points: 11,
          playerName: 'p1',
          grandPrixName: 'gp1',
        ),
        bestQualiPoints: BestPointsForGp(
          points: 22,
          playerName: 'p2',
          grandPrixName: 'gp2',
        ),
        bestRacePoints: BestPointsForGp(
          points: 33,
          playerName: 'p3',
          grandPrixName: 'gp3',
        ),
        bestDriverPoints: BestPointsForDriver(
          points: 44,
          playerName: 'p4',
          driverName: 'name',
          driverSurname: 'surname',
        ),
      );
      final List<PointsForDriver> pointsForDrivers = [
        PointsForDriver(
          driverDetails: allDrivers.first,
          points: 11,
        ),
        PointsForDriver(
          driverDetails: allDrivers[1],
          points: 22,
        ),
        PointsForDriver(
          driverDetails: allDrivers.last,
          points: 33,
        ),
      ];
      StatsState? state;

      blocTest(
        'should emit new stats type and new grouped stats without players '
        'points for driver if new stats type is grouped',
        build: () => createCubit(),
        setUp: () {
          seasonCubit.mockState(expectedState: currentSeason);
          createPlayersPodiumStats.mock(
            playersPodium: playersPodium,
          );
          createPointsHistoryStats.mock(
            pointsHistory: pointsHistory,
          );
          getDetailsOfAllDriversFromSeasonUseCase.mock(
            expectedDetailsOfAllDriversFromSeason: allDrivers,
          );
          createBestPoints.mock(
            expectedBestPoints: bestPoints,
          );
        },
        act: (cubit) => cubit.onStatsTypeChanged(StatsType.grouped),
        expect: () => [
          state = const StatsState(
            status: StatsStateStatus.changingStatsType,
          ),
          state!.copyWith(
            status: StatsStateStatus.completed,
            stats: GroupedStats(
              playersPodium: playersPodium,
              bestPoints: bestPoints,
              pointsHistory: pointsHistory,
              detailsOfDriversFromSeason: [
                allDrivers.last,
                allDrivers.first,
                allDrivers[1],
              ],
              playersPointsForDriver: [],
            ),
          ),
        ],
      );

      blocTest(
        'should emit new stats type and new individual stats if new stats type '
        'is individual',
        build: () => createCubit(),
        setUp: () {
          seasonCubit.mockState(expectedState: currentSeason);
          createPointsHistoryStats.mock(
            pointsHistory: pointsHistory,
          );
          createBestPoints.mock(
            expectedBestPoints: bestPoints,
          );
          createLoggedUserPointsForDriversStats.mock(
            expectedPointsForDrivers: pointsForDrivers,
          );
        },
        act: (cubit) => cubit.onStatsTypeChanged(StatsType.individual),
        expect: () => [
          state = const StatsState(
            status: StatsStateStatus.changingStatsType,
          ),
          state!.copyWith(
            status: StatsStateStatus.completed,
            stats: IndividualStats(
              bestPoints: bestPoints,
              pointsHistory: pointsHistory,
              pointsForDrivers: pointsForDrivers,
            ),
          ),
        ],
      );
    },
  );

  group(
    'onDriverChanged, ',
    () {
      const int currentSeason = 2024;
      final List<PlayerPoints> playersPointsForDriver = [
        PlayerPoints(
          player: const PlayerCreator(id: 'p1').create(),
          points: 22.22,
        ),
        PlayerPoints(
          player: const PlayerCreator(id: 'p2').create(),
          points: 33.33,
        ),
      ];
      StatsState? state;

      blocTest(
        'should do nothing if stats are individual',
        build: () => createCubit(),
        seed: () => const StatsState(
          stats: IndividualStats(),
        ),
        act: (cubit) => cubit.onDriverChanged('d1'),
        expect: () => [],
      );

      blocTest(
        'should emit state with with GroupedStats with updated '
        'playersPointsForDriver',
        build: () => createCubit(),
        setUp: () {
          seasonCubit.mockState(expectedState: currentSeason);
          createPointsForDriverStats.mock(
            playersPoints: playersPointsForDriver,
          );
        },
        seed: () => state = const StatsState(
          stats: GroupedStats(
            playersPointsForDriver: [],
          ),
        ),
        act: (cubit) => cubit.onDriverChanged('d1'),
        expect: () => [
          state = state!.copyWith(
            status: StatsStateStatus.pointsForDriverLoading,
          ),
          state!.copyWith(
            status: StatsStateStatus.completed,
            stats: GroupedStats(
              playersPointsForDriver: playersPointsForDriver,
            ),
          ),
        ],
        verify: (_) => verify(
          () => createPointsForDriverStats.call(
            season: currentSeason,
            seasonDriverId: 'd1',
          ),
        ).called(1),
      );
    },
  );
}
