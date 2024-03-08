import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injection.dart';
import '../../config/bet_points_config.dart';

part 'safety_car_and_red_flag_points_provider.g.dart';

@riverpod
int? safetyCarAndRedFlagPoints(
  SafetyCarAndRedFlagPointsRef ref, {
  bool? resultsVal,
  bool? betVal,
}) {
  if (resultsVal == null) return null;
  if (betVal == null) return null;
  return resultsVal == betVal
      ? getIt<BetPointsConfig>().raceSafetyCarAndRedFlag
      : 0;
}
