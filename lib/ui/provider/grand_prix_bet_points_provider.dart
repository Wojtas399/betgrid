import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../model/grand_prix_bet_points.dart';

part 'grand_prix_bet_points_provider.g.dart';

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
        );
