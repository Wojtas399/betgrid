import 'package:betgrid_shared/firebase/model/user_stats_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_user_stats_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../mapper/player_stats_mapper.dart';
import '../repository.dart';
import '../../../model/player_stats.dart';
import 'player_stats_repository.dart';

@LazySingleton(as: PlayerStatsRepository)
class PlayerStatsRepositoryImpl extends Repository<PlayerStats>
    implements PlayerStatsRepository {
  final FirebaseUserStatsService _fireUserStatsService;
  final PlayerStatsMapper _playerStatsMapper;
  final _getPlayerStatsByPlayerIdAndSeasonMutex = Mutex();

  PlayerStatsRepositoryImpl(
    this._fireUserStatsService,
    this._playerStatsMapper,
  );

  @override
  Stream<PlayerStats?> getByPlayerIdAndSeason({
    required String playerId,
    required int season,
  }) async* {
    bool didRelease = false;
    await _getPlayerStatsByPlayerIdAndSeasonMutex.acquire();
    await for (final allPlayerStats in repositoryState$) {
      PlayerStats? matchingPlayerStats = allPlayerStats.firstWhereOrNull(
        (playerStats) =>
            playerStats.playerId == playerId && playerStats.season == season,
      );
      matchingPlayerStats ??= await _fetchPlayerStatsByPlayerIdAndSeason(
        playerId,
        season,
      );
      if (_getPlayerStatsByPlayerIdAndSeasonMutex.isLocked && !didRelease) {
        _getPlayerStatsByPlayerIdAndSeasonMutex.release();
        didRelease = true;
      }
      yield matchingPlayerStats;
    }
  }

  @override
  Future<void> addInitialStatsForPlayerAndSeason({
    required String playerId,
    required int season,
  }) async {
    final UserStatsDto? addedStatsDto = await _fireUserStatsService.add(
      userStatsDto: UserStatsDto(
        userId: playerId,
        season: season,
        totalPoints: 0.0,
      ),
    );
    if (addedStatsDto == null) return;
    final playerStats = _playerStatsMapper.mapFromDto(addedStatsDto);
    addEntity(playerStats);
  }

  Future<PlayerStats?> _fetchPlayerStatsByPlayerIdAndSeason(
    String playerId,
    int season,
  ) async {
    final playerStatsDto = await _fireUserStatsService.fetchForUser(
      userId: playerId,
      season: season,
    );
    if (playerStatsDto == null) return null;
    final playerStats = _playerStatsMapper.mapFromDto(playerStatsDto);
    addEntity(playerStats);
    return playerStats;
  }
}
