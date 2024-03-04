import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bonus_bet_points_provider.dart';
import 'qualifications_bet_points_provider.dart';
import 'race_bet_points_provider.dart';

part 'grand_prix_bet_points_provider.g.dart';

@Riverpod(dependencies: [
  qualificationsBetPoints,
  raceBetPoints,
  bonusBetPoints,
])
double grandPrixBetPoints(GrandPrixBetPointsRef ref) {
  final qualiBetPoints = ref.watch(qualificationsBetPointsProvider);
  final raceBetPoints = ref.watch(raceBetPointsProvider);
  final bonusBetPoints = ref.watch(bonusBetPointsProvider);
  double points = 0.0;
  points += qualiBetPoints.value ?? 0.0;
  points += raceBetPoints.value ?? 0.0;
  points += bonusBetPoints.value ?? 0.0;
  return points;
}
