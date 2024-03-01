import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../dependency_injection.dart';
import '../config/bet_points_config.dart';
import '../config/bet_points_multipliers_config.dart';

part 'qualifications_points_provider.g.dart';

@riverpod
double qualificationsPoints(
  QualificationsPointsRef ref,
  List<String> standingsByDriverIds,
  List<String?> betStandingsByDriverIds,
) {
  if (standingsByDriverIds.length != 20 ||
      betStandingsByDriverIds.length != 20) {
    throw '[qualificationsPointsProvider] Given standings have incorrect lenth';
  }
  final List<String> q1Standings = standingsByDriverIds.sublist(15, 20);
  final List<String> q2Standings = standingsByDriverIds.sublist(10, 15);
  final List<String> q3Standings = standingsByDriverIds.sublist(0, 10);
  final List<String?> betQ1Standings = betStandingsByDriverIds.sublist(15, 20);
  final List<String?> betQ2Standings = betStandingsByDriverIds.sublist(10, 15);
  final List<String?> betQ3Standings = betStandingsByDriverIds.sublist(0, 10);
  int q1Points = 0,
      q2Points = 0,
      q3Points = 0,
      numOfQ1Hits = 0,
      numOfQ2Hits = 0,
      numOfQ3Hits = 0;
  final betPoints = getIt<BetPointsConfig>();
  final betMultipliers = getIt<BetPointsMultipliersConfig>();
  for (int i = 0; i < 10; i++) {
    if (q3Standings[i] == betQ3Standings[i]) {
      q3Points += i <= 2
          ? betPoints.onePositionFromP3ToP1InQ3
          : betPoints.onePositionFromP10ToP4InQ3;
      numOfQ3Hits++;
    }
    if (i < 5) {
      if (q1Standings[i] == betQ1Standings[i]) {
        q1Points += betPoints.onePositionInQ1;
        numOfQ1Hits++;
      }
      if (q2Standings[i] == betQ2Standings[i]) {
        q2Points += betPoints.onePositionInQ2;
        numOfQ2Hits++;
      }
    }
  }
  double multiplier = 0;
  if (numOfQ1Hits == 5) multiplier += betMultipliers.perfectQ1Multiplier;
  if (numOfQ2Hits == 5) multiplier += betMultipliers.perfectQ2Multiplier;
  if (numOfQ3Hits == 10) multiplier += betMultipliers.perfectQ3Multiplier;
  return (q1Points + q2Points + q3Points) * (multiplier == 0 ? 1 : multiplier);
}
