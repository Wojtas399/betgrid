import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/season_grand_prix_bet_points/season_grand_prix_bet_points_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/player.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../../model/season_grand_prix_bet_points.dart';
import '../../../../use_case/get_finished_grand_prixes_from_season_use_case.dart';
import '../stats_model/players_podium.dart';

@injectable
class CreatePlayersPodiumStats {
  final PlayerRepository _playerRepository;
  final GetFinishedGrandPrixesFromSeasonUseCase
  _getFinishedGrandPrixesFromSeasonUseCase;
  final SeasonGrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const CreatePlayersPodiumStats(
    this._playerRepository,
    this._getFinishedGrandPrixesFromSeasonUseCase,
    this._grandPrixBetPointsRepository,
  );

  Stream<PlayersPodium?> call({required int season}) => Rx.combineLatest2(
    _playerRepository.getAll(),
    _getFinishedGrandPrixesFromSeasonUseCase(season: season),
    (
      List<Player> allPlayers,
      List<SeasonGrandPrix> finishedSeasonGrandPrixes,
    ) => (
      allPlayers: allPlayers,
      finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
    ),
  ).switchMap((data) {
    if (data.allPlayers.isEmpty || data.finishedSeasonGrandPrixes.isEmpty) {
      return Stream.value(null);
    }
    final playersIds = data.allPlayers.map((p) => p.id).toList();
    final finishedSeasonGrandPrixesIds =
        data.finishedSeasonGrandPrixes
            .map((grandPrix) => grandPrix.id)
            .toList();
    return Rx.combineLatest2(
      _grandPrixBetPointsRepository.getForPlayersAndSeasonGrandPrixes(
        season: season,
        idsOfPlayers: playersIds,
        idsOfSeasonGrandPrixes: finishedSeasonGrandPrixesIds,
      ),
      Stream.value(data.allPlayers),
      (
        List<SeasonGrandPrixBetPoints> seasonGrandPrixesBetPoints,
        List<Player> players,
      ) => _createStats(players, seasonGrandPrixesBetPoints),
    );
  });

  PlayersPodium _createStats(
    Iterable<Player> players,
    Iterable<SeasonGrandPrixBetPoints> seasonGrandPrixesBetPoints,
  ) {
    final List<PlayersPodiumPlayer> podiumData =
        players.map((Player player) {
          final Iterable<double> pointsForEachGp = seasonGrandPrixesBetPoints
              .where((betPoints) => betPoints.playerId == player.id)
              .map((betPoints) => betPoints.totalPoints);
          final double totalPoints =
              pointsForEachGp.isNotEmpty
                  ? pointsForEachGp.reduce(
                    (totalPoints, gpBetPoints) => totalPoints + gpBetPoints,
                  )
                  : 0.0;
          return PlayersPodiumPlayer(player: player, points: totalPoints);
        }).toList();
    podiumData.sort((p1, p2) => p1.points < p2.points ? 1 : -1);
    return PlayersPodium(
      p1Player: podiumData.first,
      p2Player: podiumData.length >= 2 ? podiumData[1] : null,
      p3Player: podiumData.length >= 3 ? podiumData[2] : null,
    );
  }
}
