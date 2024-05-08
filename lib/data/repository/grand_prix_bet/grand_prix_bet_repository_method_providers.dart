import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/grand_prix_bet.dart';
import 'grand_prix_bet_repository.dart';

part 'grand_prix_bet_repository_method_providers.g.dart';

@riverpod
Stream<GrandPrixBet?> grandPrixBetByPlayerIdAndGrandPrixId(
  GrandPrixBetByPlayerIdAndGrandPrixIdRef ref, {
  required String playerId,
  required String grandPrixId,
}) =>
    ref
        .watch(grandPrixBetRepositoryProvider)
        .getBetByGrandPrixIdAndPlayerId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        )
        .distinct();
