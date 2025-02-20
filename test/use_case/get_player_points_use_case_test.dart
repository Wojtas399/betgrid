import 'package:betgrid/model/player_stats.dart';
import 'package:betgrid/use_case/get_player_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/player_stats_creator.dart';
import '../mock/repository/mock_player_stats_repository.dart';

void main() {
  final playerStatsRepository = MockPlayerStatsRepository();
  late GetPlayerPointsUseCase useCase;
  const String playerId = 'p1';
  const int season = 2024;

  setUp(() {
    useCase = GetPlayerPointsUseCase(playerStatsRepository);
  });

  tearDown(() {
    reset(playerStatsRepository);
  });

  test('should return null if there is no stats for the player', () {
    playerStatsRepository.mockGetByPlayerIdAndSeason(expectedPlayerStats: null);

    final Stream<double?> playerPoints$ = useCase(
      playerId: playerId,
      season: season,
    );

    expect(playerPoints$, emits(null));
  });

  test('should emit total points for the player', () async {
    const double expectedPoints = 100.10;
    final PlayerStats stats =
        PlayerStatsCreator(totalPoints: expectedPoints).create();
    playerStatsRepository.mockGetByPlayerIdAndSeason(
      expectedPlayerStats: stats,
    );

    final Stream<double?> playerPoints$ = useCase(
      playerId: playerId,
      season: season,
    );

    expect(playerPoints$, emits(expectedPoints));
  });
}
