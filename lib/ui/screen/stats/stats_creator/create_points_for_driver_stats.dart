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
                          _combinePlayerWithStats(player, season),
                    ),
                    (List<_PlayerWithStats> playersWithStats) =>
                        _createPointsForDriver(
                      seasonDriverId,
                      playersWithStats,
                    ),
                  ),
          );

  Stream<_PlayerWithStats> _combinePlayerWithStats(Player player, int season) {
    return _playerStatsRepository
        .getByPlayerIdAndSeason(
          playerId: player.id,
          season: season,
        )
        .map(
          (PlayerStats? stats) => (
            player: player,
            stats: stats,
          ),
        );
  }

  List<PlayerPoints>? _createPointsForDriver(
    String seasonDriverId,
    List<_PlayerWithStats> playersWithStats,
  ) {
    return playersWithStats
        .where(
      (_PlayerWithStats playerWithStats) => playerWithStats.stats != null,
    )
        .map(
      (_PlayerWithStats playerWithStats) {
        final double? points = playerWithStats.stats!.pointsForDrivers
            ?.firstWhere(
              (pointsForDriver) =>
                  pointsForDriver.seasonDriverId == seasonDriverId,
            )
            .points;

        return PlayerPoints(
          player: playerWithStats.player,
          points: points ?? 0,
        );
      },
    ).toList();
  }
}

typedef _PlayerWithStats = ({Player player, PlayerStats? stats});
