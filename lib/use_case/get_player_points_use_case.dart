import 'package:injectable/injectable.dart';

import '../data/repository/player_stats/player_stats_repository.dart';
import '../model/player_stats.dart';

@injectable
class GetPlayerPointsUseCase {
  final PlayerStatsRepository _playerStatsRepository;

  const GetPlayerPointsUseCase(this._playerStatsRepository);

  Stream<double?> call({required String playerId, required int season}) {
    return _playerStatsRepository
        .getByPlayerIdAndSeason(playerId: playerId, season: season)
        .map((PlayerStats? stats) => stats?.totalPoints);
  }
}
