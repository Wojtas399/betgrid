import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/player/player_repository.dart';
import '../../../../data/repository/player_stats/player_stats_repository.dart';
import '../../../../model/player.dart';
import '../../../../model/player_stats.dart';
import '../stats_model/player_points.dart';

@injectable
class CreatePointsForDriverStats {
  final PlayerRepository _playerRepository;
  final PlayerStatsRepository _playerStatsRepository;

  const CreatePointsForDriverStats(
    this._playerRepository,
    this._playerStatsRepository,
  );

  Stream<List<PlayerPoints>?> call({
    required int season,
    required String seasonDriverId,
  }) =>
      _playerRepository.getAll().switchMap(
            (List<Player> allPlayers) => allPlayers.isEmpty
                ? Stream.value(null)
                : Rx.combineLatest(
                    allPlayers.map(
                      (Player player) =>
                          _playerStatsRepository.getStatsByPlayerIdAndSeason(
                        playerId: player.id,
                        season: season,
                      ),
                    ),
                    (List<PlayerStats?> playersStats) => _createPointsForDriver(
                      seasonDriverId,
                      allPlayers,
                      playersStats,
                    ),
                  ),
          );

  List<PlayerPoints>? _createPointsForDriver(
    String seasonDriverId,
    List<Player> allPlayers,
    List<PlayerStats?> playersStats,
  ) {
    return playersStats
        .whereType<PlayerStats>()
        .map(
          (PlayerStats playerStats) => PlayerPoints(
            player: allPlayers.firstWhere(
              (player) => player.id == playerStats.playerId,
            ),
            points: playerStats.pointsForDrivers
                .firstWhere(
                  (pointsForDriver) =>
                      pointsForDriver.seasonDriverId == seasonDriverId,
                )
                .points,
          ),
        )
        .toList();
  }
}
