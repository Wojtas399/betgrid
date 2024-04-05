import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix_bet_points.dart';
import 'grand_prix_bet_points_repository.dart';

part 'grand_prix_bet_points_repository_method_providers.g.dart';

@riverpod
Stream<GrandPrixBetPoints?> grandPrixBetPoints(
  GrandPrixBetPointsRef ref, {
  required String playerId,
  required String grandPrixId,
}) =>
    ref
        .watch(grandPrixBetPointsRepositoryProvider)
        .getPointsForPlayerByGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        )
        .distinct();
