import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import '../stats_model/points_history.dart';

@injectable
class PointsHistoryMaker {
  const PointsHistoryMaker();

  PointsHistory? prepareStats({
    required Iterable<Player> players,
    required Iterable<GrandPrix> finishedGrandPrixes,
    required Iterable<GrandPrixBetPoints?> grandPrixBetsPoints,
  }) {
    if (players.isEmpty) throw '[PointsHistoryMaker] List of players is empty';
    if (finishedGrandPrixes.isEmpty) return null;
    final List<GrandPrix> sortedFinishedGrandPrixes = [...finishedGrandPrixes];
    sortedFinishedGrandPrixes.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final List<PointsHistoryGrandPrix> chartGrandPrixes = [];
    for (final gp in sortedFinishedGrandPrixes) {
      final List<PointsHistoryPlayerPoints> playersPointsForGp = players.map(
        (Player player) {
          final gpBetPoints = grandPrixBetsPoints.firstWhereOrNull(
            (GrandPrixBetPoints? gpBetPoints) =>
                gpBetPoints?.playerId == player.id &&
                gpBetPoints?.grandPrixId == gp.id,
          );
          final double pointsFromPreviousGrandPrixes =
              chartGrandPrixes.isNotEmpty
                  ? chartGrandPrixes.last.playersPoints
                      .firstWhere((el) => el.playerId == player.id)
                      .points
                  : 0;
          return PointsHistoryPlayerPoints(
            playerId: player.id,
            points: pointsFromPreviousGrandPrixes +
                (gpBetPoints?.totalPoints ?? 0.0),
          );
        },
      ).toList();
      chartGrandPrixes.add(PointsHistoryGrandPrix(
        roundNumber: gp.roundNumber,
        playersPoints: playersPointsForGp,
      ));
    }
    return PointsHistory(
      players: players,
      grandPrixes: chartGrandPrixes,
    );
  }
}
