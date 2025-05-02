import '../../../model/player_stats.dart';

abstract interface class PlayerStatsRepository {
  Stream<PlayerStats?> getByPlayerIdAndSeason({
    required String playerId,
    required int season,
  });

  Future<void> addInitialStatsForPlayerAndSeason({
    required String playerId,
    required int season,
  });
}
