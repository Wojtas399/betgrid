import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/player/player_repository.dart';
import '../../../../data/repository/user_stats/user_stats_repository.dart';
import '../../../../model/player.dart';
import '../../../../model/user_stats.dart';
import '../stats_model/points_by_driver.dart';

@injectable
class CreatePointsForDriverStats {
  final PlayerRepository _playerRepository;
  final UserStatsRepository _userStatsRepository;

  const CreatePointsForDriverStats(
    this._playerRepository,
    this._userStatsRepository,
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

  Stream<UserStats?> _getPlayerStats(Player player) {
    return _userStatsRepository.getStatsByUserIdAndSeason(
      userId: player.id,
      season: 2025,
    );
  }

  List<PointsByDriverPlayerPoints>? _createPointsForDriver(
    String seasonDriverId,
    List<Player> allPlayers,
    List<UserStats?> playersStats,
  ) {
    return playersStats
        .whereType<UserStats>()
        .map(
          (UserStats userStats) => PointsByDriverPlayerPoints(
            player: allPlayers.firstWhere(
              (player) => player.id == userStats.userId,
            ),
            points: userStats.pointsForDrivers
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
