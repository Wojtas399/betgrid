import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../model/grand_prix_bet.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository_method_providers.dart';
import '../../../provider/grand_prix/grand_prix_id_provider.dart';
import 'player_id_provider.dart';

part 'grand_prix_bet_provider.g.dart';

@Riverpod(dependencies: [grandPrixId, playerId])
Future<GrandPrixBet?> grandPrixBet(GrandPrixBetRef ref) async {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  final String? playerId = ref.watch(playerIdProvider);
  if (grandPrixId == null || playerId == null) {
    throw '[GrandPrixBetProvider] Cannot find grand prix id or player id';
  }
  return await ref.watch(
    grandPrixBetByPlayerIdAndGrandPrixIdProvider(
      playerId: playerId,
      grandPrixId: grandPrixId,
    ).future,
  );
}
