import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../dependency_injection.dart';
import '../config/bet_points_config.dart';

part 'quali_position_bet_points_provider.g.dart';

@riverpod
int? qualiPositionBetPoints(
  QualiPositionBetPointsRef ref, {
  required List<String?> betStandings,
  List<String>? resultsStandings,
  required int positionIndex,
}) {
  if (resultsStandings == null || resultsStandings.isEmpty) return null;
  if (resultsStandings.length != betStandings.length) {
    throw '[QualiPositionBetPointsProvider] Standings arrays have different lengths';
  }
  if (positionIndex < 0) {
    throw '[QualiPositionBetPointsProvider] Incorrect value of position index';
  }
  final bool isHit =
      resultsStandings[positionIndex] == betStandings[positionIndex];
  if (!isHit) return 0;
  final betPoints = getIt<BetPointsConfig>();
  if (positionIndex >= 15) return betPoints.onePositionInQ1;
  if (positionIndex >= 10) return betPoints.onePositionInQ2;
  if (positionIndex >= 3) {
    return betPoints.onePositionFromP10ToP4InQ3;
  }
  return betPoints.onePositionFromP3ToP1InQ3;
}
