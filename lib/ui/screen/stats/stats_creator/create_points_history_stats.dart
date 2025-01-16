import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../../use_case/get_finished_grand_prixes_from_season_use_case.dart';
import '../cubit/stats_state.dart';
import '../stats_model/points_history.dart';

@injectable
class CreatePointsHistoryStats {
  final AuthRepository _authRepository;
  final PlayerRepository _playerRepository;
  final GetFinishedGrandPrixesFromSeasonUseCase
      _getFinishedGrandPrixesFromSeasonUseCase;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const CreatePointsHistoryStats(
    this._authRepository,
    this._playerRepository,
    this._getFinishedGrandPrixesFromSeasonUseCase,
    this._grandPrixBetPointsRepository,
  );

  Stream<PointsHistory?> call({
    required StatsType statsType,
    required int season,
  }) {
    return switch (statsType) {
      StatsType.grouped => _getGroupedStats(season),
      StatsType.individual => _getIndividualStats(season),
    };
  }

  Stream<PointsHistory?> _getGroupedStats(int season) {
    return Rx.combineLatest2(
      _playerRepository.getAllPlayers().whereNotNull(),
      _getFinishedGrandPrixesFromSeasonUseCase(season: season),
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
        if (data.allPlayers.isEmpty || data.finishedSeasonGrandPrixes.isEmpty) {
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
              _createStats(
            players,
            seasonGrandPrixes,
            grandPrixesBetPoints,
          ),
        );
      },
    );
  }

  Stream<PointsHistory?> _getIndividualStats(int season) {
    return Rx.combineLatest2(
      _getLoggedUser(),
      _getFinishedGrandPrixesFromSeasonUseCase(season: season),
      (
        Player? loggedUser,
        List<SeasonGrandPrix> finishedSeasonGrandPrixes,
      ) =>
          (
        loggedUser: loggedUser,
        finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
      ),
    ).switchMap(
      (data) {
        final Player? loggedUser = data.loggedUser;
        if (loggedUser == null || data.finishedSeasonGrandPrixes.isEmpty) {
          return Stream.value(null);
        }
        final finishedSeasonGrandPrixesIds = data.finishedSeasonGrandPrixes
            .map((grandPrix) => grandPrix.id)
            .toList();
        return Rx.combineLatest3(
          Stream.value(loggedUser),
          Stream.value(data.finishedSeasonGrandPrixes),
          _grandPrixBetPointsRepository
              .getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
            idsOfPlayers: [loggedUser.id],
            idsOfSeasonGrandPrixes: finishedSeasonGrandPrixesIds,
          ),
          (
            Player loggedUser,
            List<SeasonGrandPrix> seasonGrandPrixes,
            List<GrandPrixBetPoints> grandPrixesBetPoints,
          ) =>
              _createStats(
            [loggedUser],
            seasonGrandPrixes,
            grandPrixesBetPoints,
          ),
        );
      },
    );
  }

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

  Stream<Player?> _getLoggedUser() {
    return _authRepository.loggedUserId$.switchMap(
      (String? loggedUserId) => loggedUserId == null
          ? Stream.value(null)
          : _playerRepository.getPlayerById(playerId: loggedUserId),
    );
  }
}
