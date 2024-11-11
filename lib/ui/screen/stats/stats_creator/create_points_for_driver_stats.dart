import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../../model/player.dart';
import '../../../../use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import '../stats_model/points_by_driver.dart';

@injectable
class CreatePointsForDriverStats {
  final PlayerRepository _playerRepository;
  final GetFinishedGrandPrixesFromCurrentSeasonUseCase
      _getFinishedGrandPrixesFromCurrentSeasonUseCase;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final GrandPrixBetRepository _grandPrixBetRepository;

  const CreatePointsForDriverStats(
    this._playerRepository,
    this._getFinishedGrandPrixesFromCurrentSeasonUseCase,
    this._grandPrixResultsRepository,
    this._grandPrixBetPointsRepository,
    this._grandPrixBetRepository,
  );

  Stream<List<PointsByDriverPlayerPoints>?> call({
    required String driverId,
  }) =>
      Rx.combineLatest2(
        _playerRepository.getAllPlayers().whereNotNull(),
        _getFinishedGrandPrixesFromCurrentSeasonUseCase(),
        (
          List<Player> allPlayers,
          List<GrandPrix> finishedGrandPrixes,
        ) =>
            (
          allPlayers: allPlayers,
          finishedGrandPrixes: finishedGrandPrixes,
        ),
      ).switchMap(
        (data) {
          if (data.allPlayers.isEmpty || data.finishedGrandPrixes.isEmpty) {
            return Stream.value(null);
          }
          final List<String> allPlayersIds =
              data.allPlayers.map((p) => p.id).toList();
          final List<String> finishedGrandPrixesIds =
              data.finishedGrandPrixes.map((gp) => gp.id).toList();
          return Rx.combineLatest5(
            Stream.value(data.allPlayers),
            Stream.value(finishedGrandPrixesIds),
            _grandPrixResultsRepository.getGrandPrixResultsForGrandPrixes(
              idsOfGrandPrixes: finishedGrandPrixesIds,
            ),
            _grandPrixBetPointsRepository
                .getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              idsOfPlayers: allPlayersIds,
              idsOfSeasonGrandPrixes: finishedGrandPrixesIds,
            ),
            _grandPrixBetRepository
                .getGrandPrixBetsForPlayersAndSeasonGrandPrixes(
              idsOfPlayers: allPlayersIds,
              idsOfSeasonGrandPrixes: finishedGrandPrixesIds,
            ),
            (
              List<Player> allPlayers,
              List<String> finishedGrandPrixesIds,
              List<GrandPrixResults> grandPrixesResults,
              List<GrandPrixBetPoints> grandPrixesBetPoints,
              List<GrandPrixBet> grandPrixBets,
            ) =>
                _calculatePointsForDriver(
              driverId,
              allPlayers,
              finishedGrandPrixesIds,
              grandPrixesResults,
              grandPrixesBetPoints,
              grandPrixBets,
            ),
          );
        },
      );

  List<PointsByDriverPlayerPoints>? _calculatePointsForDriver(
    String driverId,
    Iterable<Player> players,
    Iterable<String> grandPrixesIds,
    Iterable<GrandPrixResults> grandPrixesResults,
    Iterable<GrandPrixBetPoints> grandPrixesBetPoints,
    Iterable<GrandPrixBet> grandPrixBets,
  ) {
    return players.map(
      (Player player) {
        final pointsForDriverInEachGp = grandPrixesIds.map(
          (String grandPrixId) {
            final gpResults = grandPrixesResults.firstWhereOrNull(
              (gpResults) => gpResults.seasonGrandPrixId == grandPrixId,
            );
            final gpBetPoints = grandPrixesBetPoints.firstWhereOrNull(
              (gpBetPoints) =>
                  gpBetPoints.seasonGrandPrixId == grandPrixId &&
                  gpBetPoints.playerId == player.id,
            );
            final gpBet = grandPrixBets.firstWhere(
              (gpBet) =>
                  gpBet.seasonGrandPrixId == grandPrixId &&
                  gpBet.playerId == player.id,
            );
            final qualiPoints = _calculatePointsForQuali(
              driverId,
              gpBetPoints?.qualiBetPoints,
              gpResults?.qualiStandingsBySeasonDriverIds,
            );
            final racePoints = _calculatePointsForRace(
              driverId,
              gpBetPoints?.raceBetPoints,
              gpResults?.raceResults,
              gpBet.dnfSeasonDriverIds,
            );
            return qualiPoints + racePoints;
          },
        );
        final double totalPointsForDriver = pointsForDriverInEachGp
            .reduce((totalPoints, gpPoints) => totalPoints + gpPoints);
        return PointsByDriverPlayerPoints(
          player: player,
          points: totalPointsForDriver,
        );
      },
    ).toList();
  }

  double _calculatePointsForQuali(
    String driverId,
    QualiBetPoints? qualiBetPoints,
    List<String?>? qualiResults,
  ) {
    final int? driverStandingsIndex = qualiResults?.indexWhere(
      (qualiResultsDriverId) => qualiResultsDriverId == driverId,
    );
    if (driverStandingsIndex == null ||
        driverStandingsIndex < 0 ||
        qualiBetPoints == null) {
      return 0.0;
    }
    final List<double> pointsForEachQualiPosition = [
      qualiBetPoints.q3P1Points,
      qualiBetPoints.q3P2Points,
      qualiBetPoints.q3P3Points,
      qualiBetPoints.q3P4Points,
      qualiBetPoints.q3P5Points,
      qualiBetPoints.q3P6Points,
      qualiBetPoints.q3P7Points,
      qualiBetPoints.q3P8Points,
      qualiBetPoints.q3P9Points,
      qualiBetPoints.q3P10Points,
      qualiBetPoints.q2P11Points,
      qualiBetPoints.q2P12Points,
      qualiBetPoints.q2P13Points,
      qualiBetPoints.q2P14Points,
      qualiBetPoints.q2P15Points,
      qualiBetPoints.q1P16Points,
      qualiBetPoints.q1P17Points,
      qualiBetPoints.q1P18Points,
      qualiBetPoints.q1P19Points,
      qualiBetPoints.q1P20Points,
    ];
    return pointsForEachQualiPosition[driverStandingsIndex];
  }

  double _calculatePointsForRace(
    String driverId,
    RaceBetPoints? raceBetPoints,
    RaceResults? raceResults,
    List<String?>? betDnfDriverIds,
  ) {
    if (raceResults == null || raceBetPoints == null) return 0.0;
    double points = 0.0;
    if (raceResults.p1SeasonDriverId == driverId) {
      points += raceBetPoints.p1Points;
    } else if (raceResults.p2SeasonDriverId == driverId) {
      points += raceBetPoints.p2Points;
    } else if (raceResults.p3SeasonDriverId == driverId) {
      points += raceBetPoints.p3Points;
    } else if (raceResults.p10SeasonDriverId == driverId) {
      points += raceBetPoints.p10Points;
    }
    if (raceResults.fastestLapSeasonDriverId == driverId) {
      points += raceBetPoints.fastestLapPoints;
    }
    if (raceResults.dnfSeasonDriverIds.contains(driverId) &&
        betDnfDriverIds?.contains(driverId) == true) {
      final int dnfIndex = betDnfDriverIds!.indexWhere(
        (String? betDriverId) => betDriverId == driverId,
      );
      final List<double> pointsForEachDnfBet = [
        raceBetPoints.dnfDriver1Points,
        raceBetPoints.dnfDriver2Points,
        raceBetPoints.dnfDriver3Points,
      ];
      points += pointsForEachDnfBet[dnfIndex];
    }
    return points;
  }
}
