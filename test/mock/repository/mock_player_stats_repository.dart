import 'package:betgrid/data/repository/player_stats/player_stats_repository.dart';
import 'package:betgrid/model/player_stats.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayerStatsRepository extends Mock implements PlayerStatsRepository {
  void mockGetByPlayerIdAndSeason({
    PlayerStats? expectedPlayerStats,
  }) {
    when(
      () => getByPlayerIdAndSeason(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Stream.value(expectedPlayerStats));
  }

  void mockAddInitialStatsForPlayerAndSeason() {
    when(
      () => addInitialStatsForPlayerAndSeason(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
