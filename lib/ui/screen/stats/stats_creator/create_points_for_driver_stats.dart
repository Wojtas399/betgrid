import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/player/player_repository.dart';
import '../../../../data/repository/player_stats/player_stats_repository.dart';
import '../../../../model/player.dart';
import '../../../../model/player_stats.dart';
import '../stats_model/points_by_driver.dart';

@injectable
class CreatePointsForDriverStats {
  final PlayerRepository _playerRepository;
  final PlayerStatsRepository _playerStatsRepository;

  const CreatePointsForDriverStats(
    this._playerRepository,
    this._playerStatsRepository,
  );

  Stream<List<PointsByDriverPlayerPoints>?> call({
    required String seasonDriverId,
  }) =>
      _playerRepository.getAllPlayers().switchMap(
            (List<Player>? allPlayers) => allPlayers?.isNotEmpty == true
                ? Rx.combineLatest(
                    allPlayers!.map(_getPlayerStats),
                    (playersStats) => _createPointsForDriver(
                      seasonDriverId,
                      allPlayers,
                      playersStats,
                    ),
                  )
                : Stream.value(null),
          );

  Stream<PlayerStats?> _getPlayerStats(Player player) {
    return _playerStatsRepository.getStatsByPlayerIdAndSeason(
      playerId: player.id,
      season: 2025,
    );
  }

  List<PointsByDriverPlayerPoints>? _createPointsForDriver(
    String seasonDriverId,
    List<Player> allPlayers,
    List<PlayerStats?> playersStats,
  ) {
    return playersStats
        .whereType<PlayerStats>()
        .map(
          (PlayerStats playerStats) => PointsByDriverPlayerPoints(
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
