import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'grand_prix/all_grand_prixes_provider.dart';
import 'grand_prix_bet_points_provider.dart';

part 'player_points_provider.g.dart';

@riverpod
double? playerPoints(
  PlayerPointsRef ref, {
  required String playerId,
}) {
  final allGrandPrixes = ref.watch(allGrandPrixesProvider);
  if (allGrandPrixes.value == null) return null;
  double points = 0.0;
  for (final grandPrix in allGrandPrixes.value!) {
    final grandPrixPoints = ref.watch(
      grandPrixBetPointsProvider(
        grandPrixId: grandPrix.id,
        playerId: playerId,
      ).select((state) => state.value?.totalPoints),
    );
    points += grandPrixPoints ?? 0;
  }
  return points;
}
