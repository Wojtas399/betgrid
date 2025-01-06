import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../firebase/service/firebase_player_stats_service.dart';
import '../../mapper/player_stats_mapper.dart';
import '../repository.dart';
import '../../../model/player_stats.dart';
import 'player_stats_repository.dart';

@LazySingleton(as: PlayerStatsRepository)
class PlayerStatsRepositoryImpl extends Repository<PlayerStats>
    implements PlayerStatsRepository {
  final FirebasePlayerStatsService _firebasePlayerStatsService;
  final PlayerStatsMapper _playerStatsMapper;

  PlayerStatsRepositoryImpl(
    this._firebasePlayerStatsService,
    this._playerStatsMapper,
  );

  @override
  Stream<PlayerStats?> getStatsByPlayerIdAndSeason({
    required String playerId,
    required int season,
  }) async* {
    await for (final allPlayerStats in repositoryState$) {
      PlayerStats? matchingPlayerStats = allPlayerStats.firstWhereOrNull(
        (playerStats) =>
            playerStats.playerId == playerId && playerStats.season == season,
      );
      matchingPlayerStats ??=
          await _fetchPlayerStatsByPlayerIdAndSeason(playerId, season);
      yield matchingPlayerStats;
    }
  }

  Future<PlayerStats?> _fetchPlayerStatsByPlayerIdAndSeason(
    String playerId,
    int season,
  ) async {
    final playerStatsDto =
        await _firebasePlayerStatsService.fetchPlayerStatsByPlayerIdAndSeason(
      playerId: playerId,
      season: season,
    );
    if (playerStatsDto == null) return null;
    final playerStats = _playerStatsMapper.mapFromDto(playerStatsDto);
    addEntity(playerStats);
    return playerStats;
  }
}
