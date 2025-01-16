import 'package:betgrid/data/repository/player_stats/player_stats_repository.dart';
import 'package:betgrid/model/player_stats.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayerStatsRepository extends Mock implements PlayerStatsRepository {
  void mockGetStatsByPlayerIdAndSeason({
    PlayerStats? expectedPlayerStats,
  }) {
    when(
      () => getStatsByPlayerIdAndSeason(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Stream.value(expectedPlayerStats));
  }
}
