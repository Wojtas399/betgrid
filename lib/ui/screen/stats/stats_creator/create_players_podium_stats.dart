import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import '../../../../use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import '../stats_model/players_podium.dart';

@injectable
class CreatePlayersPodiumStats {
  final PlayerRepository _playerRepository;
  final GetFinishedGrandPrixesFromCurrentSeasonUseCase
      _getFinishedGrandPrixesFromCurrentSeasonUseCase;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const CreatePlayersPodiumStats(
    this._playerRepository,
    this._getFinishedGrandPrixesFromCurrentSeasonUseCase,
    this._grandPrixBetPointsRepository,
  );

  Stream<PlayersPodium?> call() => Rx.combineLatest2(
        _playerRepository.getAllPlayers().whereNotNull(),
        _getFinishedGrandPrixesFromCurrentSeasonUseCase(),
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
          final playersIds = data.allPlayers.map((p) => p.id).toList();
          final grandPrixesIds =
              data.finishedGrandPrixes.map((gp) => gp.id).toList();
          return Rx.combineLatest2(
            _grandPrixBetPointsRepository
                .getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              idsOfPlayers: playersIds,
              idsOfSeasonGrandPrixes: grandPrixesIds,
            ),
            Stream.value(data.allPlayers),
            (
              List<GrandPrixBetPoints> grandPrixesBetPoints,
              List<Player> players,
            ) =>
                _createStats(players, grandPrixesBetPoints),
          );
        },
      );

  PlayersPodium _createStats(
    Iterable<Player> players,
    Iterable<GrandPrixBetPoints> grandPrixesBetPoints,
  ) {
    final List<PlayersPodiumPlayer> podiumData = players.map(
      (Player player) {
        final Iterable<double> pointsForEachGp = grandPrixesBetPoints
            .where((betPoints) => betPoints.playerId == player.id)
            .map((betPoints) => betPoints.totalPoints);
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
