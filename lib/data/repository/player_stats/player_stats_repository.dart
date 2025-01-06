import '../../../model/player_stats.dart';

abstract interface class PlayerStatsRepository {
  Stream<PlayerStats?> getStatsByPlayerIdAndSeason({
    required String playerId,
    required int season,
  });
}
