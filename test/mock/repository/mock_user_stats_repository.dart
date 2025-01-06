import 'package:betgrid/data/repository/user_stats/user_stats_repository.dart';
import 'package:betgrid/model/user_stats.dart';
import 'package:mocktail/mocktail.dart';

class MockUserStatsRepository extends Mock implements UserStatsRepository {
  void mockGetStatsByUserIdAndSeason({
    UserStats? expectedUserStats,
  }) {
    when(
      () => getStatsByUserIdAndSeason(
        userId: any(named: 'userId'),
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Stream.value(expectedUserStats));
  }
}
