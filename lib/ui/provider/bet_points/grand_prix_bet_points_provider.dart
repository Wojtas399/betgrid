import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bonus_bet_points_provider.dart';
import 'quali_bet_points_provider.dart';
import 'race_bet_points_provider.dart';

part 'grand_prix_bet_points_provider.g.dart';

@Riverpod(dependencies: [qualiBetPoints, raceBetPoints, bonusBetPoints])
double grandPrixBetPoints(GrandPrixBetPointsRef ref) {
  final qualiBetPoints = ref.watch(
    qualiBetPointsProvider.select(
      (state) => state.value?.totalPoints,
    ),
  );
  final raceBetPoints = ref.watch(
    raceBetPointsProvider.select(
      (state) => state.value?.totalPoints,
    ),
  );
  final bonusBetPoints = ref.watch(
    bonusBetPointsProvider.select(
      (state) => state.value?.totalPoints,
    ),
  );
  double points = 0.0;
  points += qualiBetPoints ?? 0.0;
  points += raceBetPoints ?? 0.0;
  points += bonusBetPoints ?? 0.0;
  return points;
}
