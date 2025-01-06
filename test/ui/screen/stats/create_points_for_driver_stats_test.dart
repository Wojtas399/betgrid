import 'package:betgrid/model/player.dart';
import 'package:betgrid/model/user_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_points_for_driver_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/player_creator.dart';
import '../../../creator/player_stats_creator.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/repository/mock_user_stats_repository.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final userStatsRepository = MockUserStatsRepository();
  late CreatePointsForDriverStats createPointsForDriverStats;

  setUp(() {
    createPointsForDriverStats = CreatePointsForDriverStats(
      playerRepository,
      userStatsRepository,
    );
  });

  tearDown(() {
    reset(playerRepository);
    reset(userStatsRepository);
  });

  test(
    'should emit null if list of all players is null',
    () async {
      playerRepository.mockGetAllPlayers();

      final Stream<List<PointsByDriverPlayerPoints>?> pointsForDriver$ =
          createPointsForDriverStats(
        seasonDriverId: 'd1',
      );

      expect(await pointsForDriver$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
    },
  );

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
      final List<Player> allPlayers = [
        const PlayerCreator(id: 'p1').create(),
        const PlayerCreator(id: 'p2').create(),
        const PlayerCreator(id: 'p3').create(),
      ];
      final UserStats player1Stats = PlayerStatsCreator(
        userId: 'p1',
        pointsForDrivers: const [
          UserStatsPointsForDriver(
            seasonDriverId: seasonDriverId,
            points: 11.1,
          ),
          UserStatsPointsForDriver(
            seasonDriverId: 'sd2',
            points: 22.2,
          ),
          UserStatsPointsForDriver(
            seasonDriverId: 'sd3',
            points: 33.3,
          ),
        ],
      ).create();
      final UserStats player2Stats = PlayerStatsCreator(
        userId: 'p2',
        pointsForDrivers: const [
          UserStatsPointsForDriver(
            seasonDriverId: 'sd3',
            points: 11.1,
          ),
          UserStatsPointsForDriver(
            seasonDriverId: 'sd2',
            points: 22.2,
          ),
          UserStatsPointsForDriver(
            seasonDriverId: seasonDriverId,
            points: 33.3,
          ),
        ],
      ).create();
      final UserStats player3Stats = PlayerStatsCreator(
        userId: 'p3',
        pointsForDrivers: const [
          UserStatsPointsForDriver(
            seasonDriverId: 'sd2',
            points: 99.9,
          ),
          UserStatsPointsForDriver(
            seasonDriverId: seasonDriverId,
            points: 88.8,
          ),
          UserStatsPointsForDriver(
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
      playerRepository.mockGetAllPlayers(players: allPlayers);
      when(
        () => userStatsRepository.getStatsByUserIdAndSeason(
          userId: allPlayers.first.id,
          season: 2025,
        ),
      ).thenAnswer((_) => Stream.value(player1Stats));
      when(
        () => userStatsRepository.getStatsByUserIdAndSeason(
          userId: allPlayers[1].id,
          season: 2025,
        ),
      ).thenAnswer((_) => Stream.value(player2Stats));
      when(
        () => userStatsRepository.getStatsByUserIdAndSeason(
          userId: allPlayers.last.id,
          season: 2025,
        ),
      ).thenAnswer((_) => Stream.value(player3Stats));

      final Stream<List<PointsByDriverPlayerPoints>?> pointsForDriver$ =
          createPointsForDriverStats(
        seasonDriverId: seasonDriverId,
      );

      expect(await pointsForDriver$.first, expectedPoints);
      verify(playerRepository.getAllPlayers).called(1);
      verify(
        () => userStatsRepository.getStatsByUserIdAndSeason(
          userId: allPlayers.first.id,
          season: 2025,
        ),
      ).called(1);
      verify(
        () => userStatsRepository.getStatsByUserIdAndSeason(
          userId: allPlayers[1].id,
          season: 2025,
        ),
      ).called(1);
      verify(
        () => userStatsRepository.getStatsByUserIdAndSeason(
          userId: allPlayers.last.id,
          season: 2025,
        ),
      ).called(1);
    },
  );
}
