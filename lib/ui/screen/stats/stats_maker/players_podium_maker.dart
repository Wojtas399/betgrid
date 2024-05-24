import 'package:injectable/injectable.dart';

import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import '../stats_model/players_podium.dart';

@injectable
class PlayersPodiumMaker {
  const PlayersPodiumMaker();

  PlayersPodium? prepareStats({
    required Iterable<Player> players,
    required Iterable<GrandPrixBetPoints?> grandPrixBetsPoints,
  }) {
    if (players.isEmpty) throw '[PlayersPodiumMaker] List of players is empty';
    if (grandPrixBetsPoints.isEmpty) return null;
    final List<PlayersPodiumPlayer> podiumData = players.map(
      (Player player) {
        final Iterable<double> pointsForEachGp = grandPrixBetsPoints
            .where((betPoints) => betPoints?.playerId == player.id)
            .map((betPoints) => betPoints?.totalPoints ?? 0.0);
        final double totalPoints = pointsForEachGp.isNotEmpty
            ? pointsForEachGp.reduce(
                (totalPoints, gpBetPoints) => totalPoints + gpBetPoints,
              )
            : 0.0;
        return PlayersPodiumPlayer(player: player, points: totalPoints);
      },
    ).toList();
    podiumData.sort((p1, p2) => p1.points < p2.points ? 1 : -1);
    return PlayersPodium(
      p1Player: podiumData.first,
      p2Player: podiumData.length >= 2 ? podiumData[1] : null,
      p3Player: podiumData.length >= 3 ? podiumData[2] : null,
    );
  }
}
