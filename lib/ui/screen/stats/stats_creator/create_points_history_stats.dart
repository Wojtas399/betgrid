import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/season_grand_prix_bet_points/season_grand_prix_bet_points_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/season_grand_prix_bet_points.dart';
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
  final SeasonGrandPrixBetPointsRepository _seasonGrandPrixBetPointsRepository;

  const CreatePointsHistoryStats(
    this._authRepository,
    this._playerRepository,
    this._getFinishedGrandPrixesFromSeasonUseCase,
    this._seasonGrandPrixBetPointsRepository,
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
      return Rx.combineLatest3(
        Stream.value(data.allPlayers),
        Stream.value(data.finishedSeasonGrandPrixes),
        _seasonGrandPrixBetPointsRepository
            .getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              season: season,
              idsOfPlayers: playersIds,
              idsOfSeasonGrandPrixes: finishedSeasonGrandPrixesIds,
            ),
        (
          List<Player> players,
          List<SeasonGrandPrix> seasonGrandPrixes,
          List<SeasonGrandPrixBetPoints> seasonGrandPrixesBetPoints,
        ) {
          final statsData = (
            players: players,
            seasonGrandPrixes: seasonGrandPrixes,
            seasonGrandPrixesBetPoints: seasonGrandPrixesBetPoints,
          );
          return _createStats(statsData);
        },
      );
    });
  }

  Stream<PointsHistory?> _getIndividualStats(int season) {
    return Rx.combineLatest2(
      _getLoggedUser(),
      _getFinishedGrandPrixesFromSeasonUseCase(season: season),
      (Player? loggedUser, List<SeasonGrandPrix> finishedSeasonGrandPrixes) => (
        loggedUser: loggedUser,
        finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
      ),
    ).switchMap((data) {
      final Player? loggedUser = data.loggedUser;
      if (loggedUser == null || data.finishedSeasonGrandPrixes.isEmpty) {
        return Stream.value(null);
      }
      final finishedSeasonGrandPrixesIds =
          data.finishedSeasonGrandPrixes
              .map((grandPrix) => grandPrix.id)
              .toList();
      return Rx.combineLatest3(
        Stream.value(loggedUser),
        Stream.value(data.finishedSeasonGrandPrixes),
        _seasonGrandPrixBetPointsRepository
            .getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              season: season,
              idsOfPlayers: [loggedUser.id],
              idsOfSeasonGrandPrixes: finishedSeasonGrandPrixesIds,
            ),
        (
          Player loggedUser,
          List<SeasonGrandPrix> seasonGrandPrixes,
          List<SeasonGrandPrixBetPoints> seasonGrandPrixesBetPoints,
        ) {
          final statsData = (
            players: [loggedUser],
            seasonGrandPrixes: seasonGrandPrixes,
            seasonGrandPrixesBetPoints: seasonGrandPrixesBetPoints,
          );
          return _createStats(statsData);
        },
      );
    });
  }

  PointsHistory _createStats(_StatsData data) {
    final List<SeasonGrandPrix> sortedFinishedSeasonGrandPrixes = [
      ...data.seasonGrandPrixes,
    ]..sortByRoundNumber();
    final List<PointsHistoryGrandPrix> chartGrandPrixes = [];
    for (final seasonGp in sortedFinishedSeasonGrandPrixes) {
      final List<PointsHistoryPlayerPoints> playersPointsForGp =
          data.players.map((Player player) {
            final gpBetPoints = data.seasonGrandPrixesBetPoints
                .firstWhereOrNull(
                  (SeasonGrandPrixBetPoints? gpBetPoints) =>
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
              points:
                  pointsFromPreviousGrandPrixes +
                  (gpBetPoints?.totalPoints ?? 0.0),
            );
          }).toList();
      chartGrandPrixes.add(
        PointsHistoryGrandPrix(
          roundNumber: seasonGp.roundNumber,
          playersPoints: playersPointsForGp,
        ),
      );
    }
    return PointsHistory(players: data.players, grandPrixes: chartGrandPrixes);
  }

  Stream<Player?> _getLoggedUser() {
    return _authRepository.loggedUserId$.switchMap(
      (String? loggedUserId) =>
          loggedUserId == null
              ? Stream.value(null)
              : _playerRepository.getById(loggedUserId),
    );
  }
}

typedef _StatsData =
    ({
      Iterable<Player> players,
      Iterable<SeasonGrandPrix> seasonGrandPrixes,
      Iterable<SeasonGrandPrixBetPoints> seasonGrandPrixesBetPoints,
    });

extension _SeasonGrandPrixesListX on List<SeasonGrandPrix> {
  void sortByRoundNumber() {
    sort((gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber));
  }
}
