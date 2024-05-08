import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository_method_providers.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';

part 'points_for_driver_in_grand_prix_provider.g.dart';

@riverpod
Future<double> pointsForDriverInGrandPrix(
  PointsForDriverInGrandPrixRef ref, {
  required String playerId,
  required String grandPrixId,
  required String driverId,
  required GrandPrixBetPoints grandPrixBetPoints,
}) async {
  final double pointsForQuali = await _getPointsForDriverInQuali(
    playerId,
    grandPrixId,
    driverId,
    grandPrixBetPoints.qualiBetPoints,
    ref,
  );
  final double pointsForRace = await _getPointsForDriverInRace(
    playerId,
    grandPrixId,
    driverId,
    grandPrixBetPoints.raceBetPoints,
    ref,
  );
  return pointsForQuali + pointsForRace;
}

Future<double> _getPointsForDriverInQuali(
  String playerId,
  String grandPrixId,
  String driverId,
  QualiBetPoints? qualiBetPoints,
  PointsForDriverInGrandPrixRef ref,
) async {
  final List<String?>? qualiResults = await ref.watch(
    grandPrixResultsProvider(grandPrixId: grandPrixId).selectAsync(
      (GrandPrixResults? results) => results?.qualiStandingsByDriverIds,
    ),
  );
  if (qualiResults != null && qualiBetPoints != null) {
    final int driverStandingsIndex = qualiResults.indexWhere(
      (qualiResultsDriverId) => qualiResultsDriverId == driverId,
    );
    if (driverStandingsIndex >= 0) {
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
  }
  return 0.0;
}

Future<double> _getPointsForDriverInRace(
  String playerId,
  String grandPrixId,
  String driverId,
  RaceBetPoints? raceBetPoints,
  PointsForDriverInGrandPrixRef ref,
) async {
  final RaceResults? raceResults = await ref.watch(
    grandPrixResultsProvider(grandPrixId: grandPrixId).selectAsync(
      (GrandPrixResults? results) => results?.raceResults,
    ),
  );
  double points = 0.0;
  if (raceResults != null && raceBetPoints != null) {
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
    final List<String?>? betDnfDriverIds = (await getIt
            .get<GrandPrixBetRepository>()
            .getBetByGrandPrixIdAndPlayerId(
              playerId: playerId,
              grandPrixId: grandPrixId,
            )
            .first)
        ?.dnfDriverIds;
    if (raceResults.dnfDriverIds.contains(driverId) &&
        betDnfDriverIds?.contains(driverId) == true) {
      final int dnfIndex = betDnfDriverIds!.indexWhere(
        (betDriverId) => betDriverId == driverId,
      );
      final List<double> pointsForEachDnfBet = [
        raceBetPoints.dnfDriver1Points,
        raceBetPoints.dnfDriver2Points,
        raceBetPoints.dnfDriver3Points,
      ];
      points += pointsForEachDnfBet[dnfIndex];
    }
  }
  return points;
}
