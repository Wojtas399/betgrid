import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injection.dart';
import '../../config/bet_points_config.dart';

part 'race_single_bet_points_provider.g.dart';

enum RacePositionType { p1, p2, p3, p10, fastestLap }

@riverpod
int? raceSingleBetPoints(
  RaceSingleBetPointsRef ref, {
  required RacePositionType positionType,
  String? betDriverId,
  String? resultsDriverId,
}) {
  if (resultsDriverId == null) return null;
  if (betDriverId != resultsDriverId) return 0;
  final betPointsConfig = getIt<BetPointsConfig>();
  return switch (positionType) {
    RacePositionType.p1 => betPointsConfig.raceP1,
    RacePositionType.p2 => betPointsConfig.raceP2,
    RacePositionType.p3 => betPointsConfig.raceP3,
    RacePositionType.p10 => betPointsConfig.raceP10,
    RacePositionType.fastestLap => betPointsConfig.raceFastestLap,
  };
}
