import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/grand_prix_bet.dart';
import 'grand_prix/grand_prix_id_provider.dart';
import 'player/player_id_provider.dart';

part 'grand_prix_bet_provider.g.dart';

@Riverpod(dependencies: [grandPrixId, playerId])
Stream<GrandPrixBet?> grandPrixBet(GrandPrixBetRef ref) {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  final String? playerId = ref.watch(playerIdProvider);
  if (grandPrixId == null || playerId == null) {
    throw '[GrandPrixBetProvider] Cannot find grand prix id or player id';
  }
  return ref
      .watch(grandPrixBetRepositoryProvider)
      .getBetByGrandPrixIdAndPlayerId(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
}
