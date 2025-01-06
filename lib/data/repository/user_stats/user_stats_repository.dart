import '../../../model/user_stats.dart';

abstract interface class UserStatsRepository {
  Stream<UserStats?> getStatsByUserIdAndSeason({
    required String userId,
    required int season,
  });
}
