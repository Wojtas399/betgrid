import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import '../../../../use_case/get_finished_grand_prixes_use_case.dart';
import '../../../../use_case/get_grand_prixes_bet_points_use_case.dart';
import '../stats_model/points_history.dart';

@injectable
class PointsHistoryMaker {
  final PlayerRepository _playerRepository;
  final GetFinishedGrandPrixesUseCase _getFinishedGrandPrixesUseCase;
  final GetGrandPrixesBetPointsUseCase _getGrandPrixesBetPointsUseCase;

  const PointsHistoryMaker(
    this._playerRepository,
    this._getFinishedGrandPrixesUseCase,
    this._getGrandPrixesBetPointsUseCase,
  );

  Stream<PointsHistory?> call() => Rx.combineLatest2(
        _playerRepository.getAllPlayers().whereNotNull(),
        _getFinishedGrandPrixesUseCase(),
        (
          List<Player> allPlayers,
          List<GrandPrix> finishedGrandPrixes,
        ) =>
            (allPlayers: allPlayers, finishedGrandPrixes: finishedGrandPrixes),
      ).switchMap(
        (data) {
          if (data.allPlayers.isEmpty || data.finishedGrandPrixes.isEmpty) {
            return Stream.value(null);
          }
          final playersIds = data.allPlayers.map((p) => p.id);
          final grandPrixesIds = data.finishedGrandPrixes.map((gp) => gp.id);
          return Rx.combineLatest3(
            Stream.value(data.allPlayers),
            Stream.value(data.finishedGrandPrixes),
            _getGrandPrixesBetPointsUseCase(
              playersIds: playersIds,
              grandPrixesIds: grandPrixesIds,
            ),
            (
              List<Player> players,
              List<GrandPrix> grandPrixes,
              List<GrandPrixBetPoints> grandPrixesBetPoints,
            ) =>
                _createStats(players, grandPrixes, grandPrixesBetPoints),
          );
        },
      );

  PointsHistory _createStats(
    Iterable<Player> players,
    Iterable<GrandPrix> grandPrixes,
    Iterable<GrandPrixBetPoints> grandPrixesBetPoints,
  ) {
    final List<GrandPrix> sortedFinishedGrandPrixes = [...grandPrixes];
    sortedFinishedGrandPrixes.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final List<PointsHistoryGrandPrix> chartGrandPrixes = [];
    for (final gp in sortedFinishedGrandPrixes) {
      final List<PointsHistoryPlayerPoints> playersPointsForGp = players.map(
        (Player player) {
          final gpBetPoints = grandPrixesBetPoints.firstWhereOrNull(
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
