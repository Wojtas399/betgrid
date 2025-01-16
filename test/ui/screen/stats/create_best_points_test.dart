import 'package:betgrid/model/driver_personal_data.dart';
import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/model/player_stats.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_best_points.dart';
import 'package:betgrid/ui/screen/stats/stats_model/best_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_basic_info_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../creator/season_driver_creator.dart';
import '../../../creator/season_grand_prix_creator.dart';
import '../../../mock/repository/mock_auth_repository.dart';
import '../../../mock/repository/mock_driver_personal_data_repository.dart';
import '../../../mock/repository/mock_grand_prix_basic_info_repository.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/repository/mock_player_stats_repository.dart';
import '../../../mock/repository/mock_season_driver_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final playerRepository = MockPlayerRepository();
  final playerStatsRepository = MockPlayerStatsRepository();
  final seasonGrandPrixRepository = MockSeasonGrandPrixRepository();
  final grandPrixBasicInfoRepository = MockGrandPrixBasicInfoRepository();
  final seasonDriverRepository = MockSeasonDriverRepository();
  final driverPersonalDataRepository = MockDriverPersonalDataRepository();
  final create = CreateBestPoints(
    authRepository,
    playerRepository,
    playerStatsRepository,
    seasonGrandPrixRepository,
    grandPrixBasicInfoRepository,
    seasonDriverRepository,
    driverPersonalDataRepository,
  );

  tearDown(() {
    reset(authRepository);
    reset(playerRepository);
    reset(playerStatsRepository);
    reset(seasonGrandPrixRepository);
    reset(grandPrixBasicInfoRepository);
    reset(seasonDriverRepository);
    reset(driverPersonalDataRepository);
  });

  test(
    'grouped, '
    'should emit best stats for all players',
    () async {
      const StatsType statsType = StatsType.grouped;
      const int season = 2025;
      final List<Player> allPlayers = [
        const PlayerCreator(id: '1', username: 'Player1').create(),
        const PlayerCreator(id: '2', username: 'Player2').create(),
        const PlayerCreator(id: '3', username: 'Player3').create(),
      ];
      final List<PlayerStats> allPlayerStats = [
        PlayerStats(
          id: 'ps1',
          playerId: allPlayers.first.id,
          season: season,
          bestGpPoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp1',
            points: 23.45,
          ),
          bestQualiPoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp2',
            points: 12.34,
          ),
          bestRacePoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp3',
            points: 11.22,
          ),
          pointsForDrivers: [
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd1',
              points: 10.11,
            ),
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd2',
              points: 20.22,
            ),
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd3',
              points: 30.33,
            ),
          ],
        ),
        PlayerStats(
          id: 'ps2',
          playerId: allPlayers[1].id,
          season: season,
          bestGpPoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp1',
            points: 98.76,
          ),
          bestQualiPoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp2',
            points: 10.42,
          ),
          bestRacePoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp3',
            points: 11.21,
          ),
          pointsForDrivers: [
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd1',
              points: 10.11,
            ),
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd2',
              points: 20.22,
            ),
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd3',
              points: 130.33,
            ),
          ],
        ),
        PlayerStats(
          id: 'ps3',
          playerId: allPlayers.last.id,
          season: season,
          bestGpPoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp1',
            points: 5.55,
          ),
          bestQualiPoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp2',
            points: 1.34,
          ),
          bestRacePoints: const PlayerStatsPointsForGp(
            seasonGrandPrixId: 'sgp3',
            points: 45.66,
          ),
          pointsForDrivers: [
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd1',
              points: 1.11,
            ),
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd2',
              points: 120.22,
            ),
            const PlayerStatsPointsForDriver(
              seasonDriverId: 'sd3',
              points: 3.33,
            ),
          ],
        ),
      ];
      final SeasonGrandPrix sgp1 = SeasonGrandPrixCreator(
        id: 'sgp1',
        grandPrixId: 'gp1',
      ).create();
      final SeasonGrandPrix sgp2 = SeasonGrandPrixCreator(
        id: 'sgp2',
        grandPrixId: 'gp2',
      ).create();
      final SeasonGrandPrix sgp3 = SeasonGrandPrixCreator(
        id: 'sgp3',
        grandPrixId: 'gp3',
      ).create();
      final SeasonDriver sd3 = const SeasonDriverCreator(
        id: 'sd3',
        driverId: 'd3',
      ).create();
      final GrandPrixBasicInfo gp1 = const GrandPrixBasicInfoCreator(
        id: 'gp1',
        name: 'Grand Prix 1',
      ).create();
      final GrandPrixBasicInfo gp2 = const GrandPrixBasicInfoCreator(
        id: 'gp2',
        name: 'Grand Prix 2',
      ).create();
      final GrandPrixBasicInfo gp3 = const GrandPrixBasicInfoCreator(
        id: 'gp3',
        name: 'Grand Prix 3',
      ).create();
      const DriverPersonalData driver3 = DriverPersonalData(
        id: 'd3',
        name: 'Driver3',
        surname: 'Surname3',
      );
      final BestPoints expectedBestPoints = BestPoints(
        bestGpPoints: BestPointsForGp(
          points: allPlayerStats[1].bestGpPoints.points,
          playerName: allPlayers[1].username,
          grandPrixName: gp1.name,
        ),
        bestQualiPoints: BestPointsForGp(
          points: allPlayerStats.first.bestQualiPoints.points,
          playerName: allPlayers.first.username,
          grandPrixName: gp2.name,
        ),
        bestRacePoints: BestPointsForGp(
          points: allPlayerStats.last.bestRacePoints.points,
          playerName: allPlayers.last.username,
          grandPrixName: gp3.name,
        ),
        bestDriverPoints: BestPointsForDriver(
          points: allPlayerStats[1].pointsForDrivers.last.points,
          playerName: allPlayers[1].username,
          driverName: driver3.name,
          driverSurname: driver3.surname,
        ),
      );
      playerRepository.mockGetAllPlayers(players: allPlayers);
      when(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers.first.id,
          season: season,
        ),
      ).thenAnswer((_) => Stream.value(allPlayerStats.first));
      when(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers[1].id,
          season: season,
        ),
      ).thenAnswer((_) => Stream.value(allPlayerStats[1]));
      when(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers.last.id,
          season: season,
        ),
      ).thenAnswer((_) => Stream.value(allPlayerStats.last));
      when(
        () => seasonGrandPrixRepository.getSeasonGrandPrixById(sgp1.id),
      ).thenAnswer((_) => Stream.value(sgp1));
      when(
        () => seasonGrandPrixRepository.getSeasonGrandPrixById(sgp2.id),
      ).thenAnswer((_) => Stream.value(sgp2));
      when(
        () => seasonGrandPrixRepository.getSeasonGrandPrixById(sgp3.id),
      ).thenAnswer((_) => Stream.value(sgp3));
      when(
        () => seasonDriverRepository.getSeasonDriverById(sd3.id),
      ).thenAnswer((_) => Stream.value(sd3));
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(gp1.id),
      ).thenAnswer((_) => Stream.value(gp1));
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(gp2.id),
      ).thenAnswer((_) => Stream.value(gp2));
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(gp3.id),
      ).thenAnswer((_) => Stream.value(gp3));
      when(
        () =>
            driverPersonalDataRepository.getDriverPersonalDataById(driver3.id),
      ).thenAnswer((_) => Stream.value(driver3));

      final groupedBestPoints$ = create(statsType: statsType, season: season);

      expect(await groupedBestPoints$.first, expectedBestPoints);
    },
  );

  test(
    'individual, '
    'should emit best stats for logged user',
    () async {
      const StatsType statsType = StatsType.individual;
      const int season = 2025;
      const String loggedUserId = 'u1';
      final Player loggedUser = const PlayerCreator(
        id: loggedUserId,
        username: 'logged user',
      ).create();
      const PlayerStats loggedUserStats = PlayerStats(
        id: 'ps1',
        playerId: loggedUserId,
        season: season,
        bestGpPoints: PlayerStatsPointsForGp(
          seasonGrandPrixId: 'sgp1',
          points: 23.45,
        ),
        bestQualiPoints: PlayerStatsPointsForGp(
          seasonGrandPrixId: 'sgp2',
          points: 12.34,
        ),
        bestRacePoints: PlayerStatsPointsForGp(
          seasonGrandPrixId: 'sgp3',
          points: 11.22,
        ),
        pointsForDrivers: [
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd1',
            points: 30.11,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd2',
            points: 20.22,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd3',
            points: 10.33,
          ),
        ],
      );
      final SeasonGrandPrix sgp1 = SeasonGrandPrixCreator(
        id: 'sgp1',
        grandPrixId: 'gp1',
      ).create();
      final SeasonGrandPrix sgp2 = SeasonGrandPrixCreator(
        id: 'sgp2',
        grandPrixId: 'gp2',
      ).create();
      final SeasonGrandPrix sgp3 = SeasonGrandPrixCreator(
        id: 'sgp3',
        grandPrixId: 'gp3',
      ).create();
      final SeasonDriver sd1 = const SeasonDriverCreator(
        id: 'sd1',
        driverId: 'd1',
      ).create();
      final GrandPrixBasicInfo gp1 = const GrandPrixBasicInfoCreator(
        id: 'gp1',
        name: 'Grand Prix 1',
      ).create();
      final GrandPrixBasicInfo gp2 = const GrandPrixBasicInfoCreator(
        id: 'gp2',
        name: 'Grand Prix 2',
      ).create();
      final GrandPrixBasicInfo gp3 = const GrandPrixBasicInfoCreator(
        id: 'gp3',
        name: 'Grand Prix 3',
      ).create();
      const DriverPersonalData driver1 = DriverPersonalData(
        id: 'd1',
        name: 'Driver1',
        surname: 'Surname1',
      );
      final BestPoints expectedBestPoints = BestPoints(
        bestGpPoints: BestPointsForGp(
          points: loggedUserStats.bestGpPoints.points,
          playerName: loggedUser.username,
          grandPrixName: gp1.name,
        ),
        bestQualiPoints: BestPointsForGp(
          points: loggedUserStats.bestQualiPoints.points,
          playerName: loggedUser.username,
          grandPrixName: gp2.name,
        ),
        bestRacePoints: BestPointsForGp(
          points: loggedUserStats.bestRacePoints.points,
          playerName: loggedUser.username,
          grandPrixName: gp3.name,
        ),
        bestDriverPoints: BestPointsForDriver(
          points: loggedUserStats.pointsForDrivers.first.points,
          playerName: loggedUser.username,
          driverName: driver1.name,
          driverSurname: driver1.surname,
        ),
      );
      authRepository.mockGetLoggedUserId(loggedUserId);
      playerRepository.mockGetPlayerById(player: loggedUser);
      playerStatsRepository.mockGetStatsByPlayerIdAndSeason(
        expectedPlayerStats: loggedUserStats,
      );
      when(
        () => seasonGrandPrixRepository.getSeasonGrandPrixById(sgp1.id),
      ).thenAnswer((_) => Stream.value(sgp1));
      when(
        () => seasonGrandPrixRepository.getSeasonGrandPrixById(sgp2.id),
      ).thenAnswer((_) => Stream.value(sgp2));
      when(
        () => seasonGrandPrixRepository.getSeasonGrandPrixById(sgp3.id),
      ).thenAnswer((_) => Stream.value(sgp3));
      seasonDriverRepository.mockGetSeasonDriverById(expectedSeasonDriver: sd1);
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(gp1.id),
      ).thenAnswer((_) => Stream.value(gp1));
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(gp2.id),
      ).thenAnswer((_) => Stream.value(gp2));
      when(
        () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(gp3.id),
      ).thenAnswer((_) => Stream.value(gp3));
      driverPersonalDataRepository.mockGetDriverPersonalDataById(
        expectedDriverPersonalData: driver1,
      );

      final individualBestPoints$ = create(
        statsType: statsType,
        season: season,
      );

      expect(await individualBestPoints$.first, expectedBestPoints);
    },
  );
}
