import 'package:betgrid/model/player.dart';
import 'package:betgrid/model/player_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_points_for_driver_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/player_creator.dart';
import '../../../creator/player_stats_creator.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/repository/mock_player_stats_repository.dart';
import '../../../mock/ui/mock_date_service.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final playerStatsRepository = MockPlayerStatsRepository();
  final dateService = MockDateService();
  late CreatePointsForDriverStats createPointsForDriverStats;

  setUp(() {
    createPointsForDriverStats = CreatePointsForDriverStats(
      playerRepository,
      playerStatsRepository,
      dateService,
    );
  });

  tearDown(() {
    reset(playerRepository);
    reset(playerStatsRepository);
    reset(dateService);
  });

  test(
    'should emit null if list of all players is empty',
    () async {
      playerRepository.mockGetAllPlayers(players: []);

      final Stream<List<PointsByDriverPlayerPoints>?> pointsForDriver$ =
          createPointsForDriverStats(
        seasonDriverId: 'd1',
      );

      expect(await pointsForDriver$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
    },
  );

  test(
    'should get stats for each player and should emit list of points for given '
    'driver received by each player',
    () async {
      const String seasonDriverId = 'sd1';
      final DateTime now = DateTime(2025);
      final List<Player> allPlayers = [
        const PlayerCreator(id: 'p1').create(),
        const PlayerCreator(id: 'p2').create(),
        const PlayerCreator(id: 'p3').create(),
      ];
      final PlayerStats player1Stats = PlayerStatsCreator(
        playerId: 'p1',
        pointsForDrivers: const [
          PlayerStatsPointsForDriver(
            seasonDriverId: seasonDriverId,
            points: 11.1,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd2',
            points: 22.2,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd3',
            points: 33.3,
          ),
        ],
      ).create();
      final PlayerStats player2Stats = PlayerStatsCreator(
        playerId: 'p2',
        pointsForDrivers: const [
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd3',
            points: 11.1,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd2',
            points: 22.2,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: seasonDriverId,
            points: 33.3,
          ),
        ],
      ).create();
      final PlayerStats player3Stats = PlayerStatsCreator(
        playerId: 'p3',
        pointsForDrivers: const [
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd2',
            points: 99.9,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: seasonDriverId,
            points: 88.8,
          ),
          PlayerStatsPointsForDriver(
            seasonDriverId: 'sd3',
            points: 77.7,
          ),
        ],
      ).create();
      final List<PointsByDriverPlayerPoints> expectedPoints = [
        PointsByDriverPlayerPoints(
          player: allPlayers.first,
          points: player1Stats.pointsForDrivers.first.points,
        ),
        PointsByDriverPlayerPoints(
          player: allPlayers[1],
          points: player2Stats.pointsForDrivers.last.points,
        ),
        PointsByDriverPlayerPoints(
          player: allPlayers.last,
          points: player3Stats.pointsForDrivers[1].points,
        ),
      ];
      dateService.mockGetNow(now: now);
      playerRepository.mockGetAllPlayers(players: allPlayers);
      when(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers.first.id,
          season: now.year,
        ),
      ).thenAnswer((_) => Stream.value(player1Stats));
      when(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers[1].id,
          season: now.year,
        ),
      ).thenAnswer((_) => Stream.value(player2Stats));
      when(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers.last.id,
          season: now.year,
        ),
      ).thenAnswer((_) => Stream.value(player3Stats));

      final Stream<List<PointsByDriverPlayerPoints>?> pointsForDriver$ =
          createPointsForDriverStats(
        seasonDriverId: seasonDriverId,
      );

      expect(await pointsForDriver$.first, expectedPoints);
      verify(playerRepository.getAllPlayers).called(1);
      verify(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers.first.id,
          season: now.year,
        ),
      ).called(1);
      verify(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers[1].id,
          season: now.year,
        ),
      ).called(1);
      verify(
        () => playerStatsRepository.getStatsByPlayerIdAndSeason(
          playerId: allPlayers.last.id,
          season: now.year,
        ),
      ).called(1);
    },
  );
}
