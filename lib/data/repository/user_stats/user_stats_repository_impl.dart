import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../firebase/service/firebase_user_stats_service.dart';
import '../../mapper/user_stats_mapper.dart';
import '../repository.dart';
import '../../../model/user_stats.dart';
import 'user_stats_repository.dart';

@LazySingleton(as: UserStatsRepository)
class UserStatsRepositoryImpl extends Repository<UserStats>
    implements UserStatsRepository {
  final FirebaseUserStatsService _firebaseUserStatsService;
  final UserStatsMapper _userStatsMapper;

  UserStatsRepositoryImpl(
    this._firebaseUserStatsService,
    this._userStatsMapper,
  );

  @override
  Stream<UserStats?> getStatsByUserIdAndSeason({
    required String userId,
    required int season,
  }) async* {
    await for (final allUserStats in repositoryState$) {
      UserStats? matchingUserStats = allUserStats.firstWhereOrNull(
        (userStats) => userStats.userId == userId && userStats.season == season,
      );
      matchingUserStats ??=
          await _fetchUserStatsByUserIdAndSeason(userId, season);
      yield matchingUserStats;
    }
  }

  Future<UserStats?> _fetchUserStatsByUserIdAndSeason(
    String userId,
    int season,
  ) async {
    final userStatsDto =
        await _firebaseUserStatsService.fetchUserStatsByUserIdAndSeason(
      userId: userId,
      season: season,
    );
    if (userStatsDto == null) return null;
    final userStats = _userStatsMapper.mapFromDto(userStatsDto);
    addEntity(userStats);
    return userStats;
  }
}
