import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../../use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import '../stats_model/points_history.dart';

@injectable
class CreatePointsHistoryStats {
  final PlayerRepository _playerRepository;
  final GetFinishedGrandPrixesFromCurrentSeasonUseCase
      _getFinishedGrandPrixesFromCurrentSeasonUseCase;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const CreatePointsHistoryStats(
    this._playerRepository,
    this._getFinishedGrandPrixesFromCurrentSeasonUseCase,
    this._grandPrixBetPointsRepository,
  );

  Stream<PointsHistory?> call() => Rx.combineLatest2(
        _playerRepository.getAllPlayers().whereNotNull(),
        _getFinishedGrandPrixesFromCurrentSeasonUseCase(),
        (
          List<Player> allPlayers,
          List<SeasonGrandPrix> finishedSeasonGrandPrixes,
        ) =>
            (
          allPlayers: allPlayers,
          finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
        ),
      ).switchMap(
        (data) {
          if (data.allPlayers.isEmpty ||
              data.finishedSeasonGrandPrixes.isEmpty) {
            return Stream.value(null);
          }
          final playersIds = data.allPlayers.map((p) => p.id).toList();
          final finishedSeasonGrandPrixesIds = data.finishedSeasonGrandPrixes
              .map((grandPrix) => grandPrix.id)
              .toList();
          return Rx.combineLatest3(
            Stream.value(data.allPlayers),
            Stream.value(data.finishedSeasonGrandPrixes),
            _grandPrixBetPointsRepository
                .getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              idsOfPlayers: playersIds,
              idsOfSeasonGrandPrixes: finishedSeasonGrandPrixesIds,
            ),
            (
              List<Player> players,
              List<SeasonGrandPrix> seasonGrandPrixes,
              List<GrandPrixBetPoints> grandPrixesBetPoints,
            ) =>
                _createStats(players, seasonGrandPrixes, grandPrixesBetPoints),
          );
        },
      );

  PointsHistory _createStats(
    Iterable<Player> players,
    Iterable<SeasonGrandPrix> seasonGrandPrixes,
    Iterable<GrandPrixBetPoints> grandPrixesBetPoints,
  ) {
    final List<SeasonGrandPrix> sortedFinishedSeasonGrandPrixes = [
      ...seasonGrandPrixes,
    ];
    sortedFinishedSeasonGrandPrixes.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final List<PointsHistoryGrandPrix> chartGrandPrixes = [];
    for (final seasonGp in sortedFinishedSeasonGrandPrixes) {
      final List<PointsHistoryPlayerPoints> playersPointsForGp = players.map(
        (Player player) {
          final gpBetPoints = grandPrixesBetPoints.firstWhereOrNull(
            (GrandPrixBetPoints? gpBetPoints) =>
                gpBetPoints?.playerId == player.id &&
                gpBetPoints?.seasonGrandPrixId == seasonGp.id,
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
        roundNumber: seasonGp.roundNumber,
        playersPoints: playersPointsForGp,
      ));
    }
    return PointsHistory(
      players: players,
      grandPrixes: chartGrandPrixes,
    );
  }
}
