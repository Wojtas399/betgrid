import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_cubit.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_model/best_points.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/ui/mock_create_best_points.dart';
import '../../../mock/ui/mock_create_players_podium_stats.dart';
import '../../../mock/ui/mock_create_points_for_driver_stats.dart';
import '../../../mock/ui/mock_create_points_history_stats.dart';
import '../../../mock/ui/mock_date_service.dart';
import '../../../mock/use_case/mock_get_details_for_all_drivers_from_season_use_case.dart';

void main() {
  final dateService = MockDateService();
  final getDetailsOfAllDriversFromSeasonUseCase =
      MockGetDetailsOfAllDriversFromSeasonUseCase();
  final createPlayersPodiumStats = MockCreatePlayersPodiumStats();
  final createPointsHistoryStats = MockCreatePointsHistoryStats();
  final createPointsForDriverStats = MockCreatePointsForDriverStats();
  final createBestPoints = MockCreateBestPoints();

  StatsCubit createCubit() => StatsCubit(
        dateService,
        getDetailsOfAllDriversFromSeasonUseCase,
        createPlayersPodiumStats,
        createPointsHistoryStats,
        createPointsForDriverStats,
        createBestPoints,
      );

  tearDown(() {
    reset(dateService);
    reset(getDetailsOfAllDriversFromSeasonUseCase);
    reset(createPlayersPodiumStats);
    reset(createPointsHistoryStats);
    reset(createPointsForDriverStats);
    reset(createBestPoints);
  });

  group(
    'initialize, ',
    () {
      const int currentSeason = 2024;
      final DateTime now = DateTime(currentSeason);
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
        dateService.mockGetNow(now: now);
      });

      tearDown(() {
        verify(createPlayersPodiumStats.call).called(1);
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
        'should emit noData status if all stats not exist',
        build: () => createCubit(),
        setUp: () {
          createPlayersPodiumStats.mock();
          createPointsHistoryStats.mock();
          getDetailsOfAllDriversFromSeasonUseCase.mock(
            expectedDetailsOfAllDriversFromSeason: [],
          );
          createBestPoints.mock();
        },
        act: (cubit) => cubit.initialize(),
        expect: () => const [
          StatsState(
            status: StatsStateStatus.noData,
          ),
        ],
      );

      blocTest(
        'should emit state with all stats data without points for driver',
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
            playersPodium: playersPodium,
            pointsHistory: pointsHistory,
            pointsByDriver: [],
            detailsOfDriversFromSeason: [
              allDrivers.last,
              allDrivers.first,
              allDrivers[1],
            ],
            bestPoints: bestPoints,
          ),
        ],
      );
    },
  );

  group(
    'onStatsTypeChanged,',
    () {
      const StatsType newStatsType = StatsType.individual;
      const int currentSeason = 2024;
      final DateTime now = DateTime(currentSeason);
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
      StatsState? state;

      blocTest(
        'should emit new stats type and new stats without points for driver',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetNow(now: now);
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
        act: (cubit) => cubit.onStatsTypeChanged(newStatsType),
        expect: () => [
          state = const StatsState(
            type: newStatsType,
            status: StatsStateStatus.changingStatsType,
          ),
          state!.copyWith(
            status: StatsStateStatus.completed,
            playersPodium: playersPodium,
            pointsHistory: pointsHistory,
            pointsByDriver: [],
            detailsOfDriversFromSeason: [
              allDrivers.last,
              allDrivers.first,
              allDrivers[1],
            ],
            bestPoints: bestPoints,
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
          () => createPointsForDriverStats.call(seasonDriverId: 'd1'),
        ).called(1),
      );
    },
  );
}
