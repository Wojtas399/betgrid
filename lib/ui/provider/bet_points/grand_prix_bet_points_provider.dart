import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bonus_bet_points_provider.dart';
import 'quali_bet_points_provider.dart';
import 'race_bet_points_provider.dart';

part 'grand_prix_bet_points_provider.g.dart';

@riverpod
double grandPrixBetPoints(
  GrandPrixBetPointsRef ref, {
  required String grandPrixId,
  required String playerId,
}) {
  final qualiBetPoints = ref.watch(qualiBetPointsProvider(
    grandPrixId: grandPrixId,
    playerId: playerId,
  ));
  final raceBetPoints = ref.watch(raceBetPointsProvider(
    grandPrixId: grandPrixId,
    playerId: playerId,
  ));
  final bonusBetPoints = ref.watch(bonusBetPointsProvider(
    grandPrixId: grandPrixId,
    playerId: playerId,
  ));
  double points = 0.0;
  points += qualiBetPoints.value ?? 0.0;
  points += raceBetPoints.value ?? 0.0;
  points += bonusBetPoints.value ?? 0.0;
  return points;
}
