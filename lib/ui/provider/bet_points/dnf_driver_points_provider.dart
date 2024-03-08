import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injection.dart';
import '../../config/bet_points_config.dart';

part 'dnf_driver_points_provider.g.dart';

@riverpod
int? dnfDriverPoints(
  DnfDriverPointsRef ref, {
  List<String>? resultsDnfDriverIds,
  String? betDnfDriverId,
}) {
  if (resultsDnfDriverIds == null) return null;
  if (betDnfDriverId == null) return 0;
  final betPointsConfig = getIt<BetPointsConfig>();
  return resultsDnfDriverIds.contains(betDnfDriverId)
      ? betPointsConfig.raceOneDnfDriver
      : 0;
}
