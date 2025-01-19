import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/model/player_stats.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_logged_user_points_for_drivers_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_for_driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/player_stats_creator.dart';
import '../../../creator/season_driver_creator.dart';
import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/repository/mock_player_stats_repository.dart';
import '../../../mock/repository/mock_season_driver_repository.dart';
import '../../../mock/use_case/mock_get_details_for_season_driver_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final playerStatsRepository = MockPlayerStatsRepository();
  final seasonDriverRepository = MockSeasonDriverRepository();
  final getDetailsForSeasonDriverUseCase =
      MockGetDetailsForSeasonDriverUseCase();
  const int season = 2025;

  late CreateLoggedUserPointsForDriversStats
      createLoggedUserPointsForDriversStats;

  setUp(() {
    createLoggedUserPointsForDriversStats =
        CreateLoggedUserPointsForDriversStats(
      authRepository,
      playerStatsRepository,
      seasonDriverRepository,
      getDetailsForSeasonDriverUseCase,
    );
  });

  tearDown(() {
    reset(authRepository);
    reset(playerStatsRepository);
    reset(seasonDriverRepository);
    reset(getDetailsForSeasonDriverUseCase);
  });

  test(
    'should emit null if logged user id is null',
    () async {
      authRepository.mockGetLoggedUserId(null);

      final Stream<List<PointsForDriver>?> pointsForDrivers$ =
          createLoggedUserPointsForDriversStats(
        season: season,
      );

      expect(await pointsForDrivers$.first, null);
    },
  );

  test(
    'should emit null if logged user stats do not exist',
    () async {
      const String loggedUserId = 'u1';
      authRepository.mockGetLoggedUserId(loggedUserId);
      playerStatsRepository.mockGetStatsByPlayerIdAndSeason();

      final Stream<List<PointsForDriver>?> pointsForDrivers$ =
          createLoggedUserPointsForDriversStats(
        season: season,
      );

      expect(await pointsForDrivers$.first, null);
    },
  );

  test(
    'should emit null if logged user list of points for drivers is empty',
    () async {
      const String loggedUserId = 'u1';
      authRepository.mockGetLoggedUserId(loggedUserId);
      playerStatsRepository.mockGetStatsByPlayerIdAndSeason(
        expectedPlayerStats: PlayerStatsCreator().create(),
      );

      final Stream<List<PointsForDriver>?> pointsForDrivers$ =
          createLoggedUserPointsForDriversStats(
        season: season,
      );

      expect(await pointsForDrivers$.first, null);
    },
  );

  test(
    'should throw null check operator exception if cannot get one of the '
    'season drivers',
    () async {
      const String loggedUserId = 'u1';
      const List<PlayerStatsPointsForDriver> pointsForDrivers = [
        PlayerStatsPointsForDriver(
          seasonDriverId: 's1',
          points: 10,
        ),
        PlayerStatsPointsForDriver(
          seasonDriverId: 's2',
          points: 20,
        ),
        PlayerStatsPointsForDriver(
          seasonDriverId: 's3',
          points: 30,
        ),
      ];
      authRepository.mockGetLoggedUserId(loggedUserId);
      playerStatsRepository.mockGetStatsByPlayerIdAndSeason(
        expectedPlayerStats: PlayerStatsCreator(
          pointsForDrivers: pointsForDrivers,
        ).create(),
      );
      when(
        () => seasonDriverRepository.getSeasonDriverById(
          pointsForDrivers.first.seasonDriverId,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const SeasonDriverCreator().create(),
        ),
      );
      when(
        () => seasonDriverRepository.getSeasonDriverById(
          pointsForDrivers[1].seasonDriverId,
        ),
      ).thenAnswer((_) => Stream.value(null));
      when(
        () => seasonDriverRepository.getSeasonDriverById(
          pointsForDrivers.last.seasonDriverId,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          const SeasonDriverCreator().create(),
        ),
      );

      Object? exception;
      try {
        final stream$ = createLoggedUserPointsForDriversStats(season: season);
        await stream$.first;
      } catch (e) {
        exception = e;
      }

      expect(exception, isA<TypeError>());
    },
  );

  test(
    'should throw null check operator exception if cannot get details for one '
    'of the season drivers',
    () async {
      const String loggedUserId = 'u1';
      const List<PlayerStatsPointsForDriver> pointsForDrivers = [
        PlayerStatsPointsForDriver(
          seasonDriverId: 's1',
          points: 10,
        ),
        PlayerStatsPointsForDriver(
          seasonDriverId: 's2',
          points: 20,
        ),
        PlayerStatsPointsForDriver(
          seasonDriverId: 's3',
          points: 30,
        ),
      ];
      final List<SeasonDriver> seasonDrivers = [
        const SeasonDriverCreator(id: 's1').create(),
        const SeasonDriverCreator(id: 's2').create(),
        const SeasonDriverCreator(id: 's3').create(),
      ];
      authRepository.mockGetLoggedUserId(loggedUserId);
      playerStatsRepository.mockGetStatsByPlayerIdAndSeason(
        expectedPlayerStats: PlayerStatsCreator(
          pointsForDrivers: pointsForDrivers,
        ).create(),
      );
      for (final seasonDriver in seasonDrivers) {
        when(
          () => seasonDriverRepository.getSeasonDriverById(seasonDriver.id),
        ).thenAnswer(
          (_) => Stream.value(seasonDriver),
        );
      }
      when(
        () => getDetailsForSeasonDriverUseCase(seasonDrivers.first),
      ).thenAnswer(
        (_) => Stream.value(
          const DriverDetailsCreator().create(),
        ),
      );
      when(
        () => getDetailsForSeasonDriverUseCase(seasonDrivers[1]),
      ).thenAnswer((_) => Stream.value(null));
      when(
        () => getDetailsForSeasonDriverUseCase(seasonDrivers.last),
      ).thenAnswer(
        (_) => Stream.value(
          const DriverDetailsCreator().create(),
        ),
      );

      Object? exception;
      try {
        final stream$ = createLoggedUserPointsForDriversStats(season: season);
        await stream$.first;
      } catch (e) {
        exception = e;
      }

      expect(exception, isA<TypeError>());
    },
  );

  test(
    'should emit list of points for drivers with driver details',
    () async {
      const String loggedUserId = 'u1';
      const List<PlayerStatsPointsForDriver> pointsForDrivers = [
        PlayerStatsPointsForDriver(
          seasonDriverId: 's1',
          points: 10,
        ),
        PlayerStatsPointsForDriver(
          seasonDriverId: 's2',
          points: 20,
        ),
        PlayerStatsPointsForDriver(
          seasonDriverId: 's3',
          points: 30,
        ),
      ];
      final List<SeasonDriver> seasonDrivers = [
        const SeasonDriverCreator(id: 's1').create(),
        const SeasonDriverCreator(id: 's2').create(),
        const SeasonDriverCreator(id: 's3').create(),
      ];
      final List<DriverDetails> driverDetails = [
        const DriverDetailsCreator(seasonDriverId: 's1').create(),
        const DriverDetailsCreator(seasonDriverId: 's2').create(),
        const DriverDetailsCreator(seasonDriverId: 's3').create(),
      ];
      List<PointsForDriver> expectedPointsForDrivers = [
        PointsForDriver(
          driverDetails: driverDetails.first,
          points: pointsForDrivers.first.points,
        ),
        PointsForDriver(
          driverDetails: driverDetails[1],
          points: pointsForDrivers[1].points,
        ),
        PointsForDriver(
          driverDetails: driverDetails.last,
          points: pointsForDrivers.last.points,
        ),
      ];
      authRepository.mockGetLoggedUserId(loggedUserId);
      playerStatsRepository.mockGetStatsByPlayerIdAndSeason(
        expectedPlayerStats: PlayerStatsCreator(
          pointsForDrivers: pointsForDrivers,
        ).create(),
      );
      for (int i = 0; i < 3; i++) {
        when(
          () => seasonDriverRepository.getSeasonDriverById(seasonDrivers[i].id),
        ).thenAnswer(
          (_) => Stream.value(seasonDrivers[i]),
        );
        when(
          () => getDetailsForSeasonDriverUseCase(seasonDrivers[i]),
        ).thenAnswer(
          (_) => Stream.value(driverDetails[i]),
        );
      }

      final stream$ = createLoggedUserPointsForDriversStats(season: season);

      expect(await stream$.first, expectedPointsForDrivers);
    },
  );
}
