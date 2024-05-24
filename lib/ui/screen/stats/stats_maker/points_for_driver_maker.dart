import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../../model/grand_prix_bet.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../../model/player.dart';
import '../stats_model/points_by_driver.dart';

@injectable
class PointsForDriverMaker {
  const PointsForDriverMaker();

  List<PointsByDriverPlayerPoints>? prepareStats({
    required String driverId,
    required Iterable<Player> players,
    required Iterable<String> grandPrixesIds,
    required Iterable<GrandPrixResults?> grandPrixesResults,
    required Iterable<GrandPrixBetPoints> grandPrixesBetPoints,
    required Iterable<GrandPrixBet> grandPrixesBets,
  }) {
    if (players.isEmpty) {
      throw '[PointsForDriverMaker] List of players is empty';
    }
    if (grandPrixesIds.isEmpty) return null;
    return players.map(
      (Player player) {
        final pointsForDriverInEachGp = grandPrixesIds.map(
          (String grandPrixId) {
            final gpResults = grandPrixesResults.firstWhereOrNull(
              (gpResults) => gpResults?.grandPrixId == grandPrixId,
            );
            final gpBetPoints = grandPrixesBetPoints.firstWhereOrNull(
              (gpBetPoints) =>
                  gpBetPoints.grandPrixId == grandPrixId &&
                  gpBetPoints.playerId == player.id,
            );
            final gpBet = grandPrixesBets.firstWhere(
              (gpBet) =>
                  gpBet.grandPrixId == grandPrixId &&
                  gpBet.playerId == player.id,
            );
            final qualiPoints = _calculatePointsForQuali(
              driverId,
              gpBetPoints?.qualiBetPoints,
              gpResults?.qualiStandingsByDriverIds,
            );
            final racePoints = _calculatePointsForRace(
              driverId,
              gpBetPoints?.raceBetPoints,
              gpResults?.raceResults,
              gpBet.dnfDriverIds,
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
    if (raceResults.p1DriverId == driverId) {
      points += raceBetPoints.p1Points;
    } else if (raceResults.p2DriverId == driverId) {
      points += raceBetPoints.p2Points;
    } else if (raceResults.p3DriverId == driverId) {
      points += raceBetPoints.p3Points;
    } else if (raceResults.p10DriverId == driverId) {
      points += raceBetPoints.p10Points;
    }
    if (raceResults.fastestLapDriverId == driverId) {
      points += raceBetPoints.fastestLapPoints;
    }
    if (raceResults.dnfDriverIds.contains(driverId) &&
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
