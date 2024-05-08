import '../../../model/grand_prix_bet.dart';

abstract interface class GrandPrixBetRepository {
  Stream<List<GrandPrixBet>?> getAllGrandPrixBetsForPlayer({
    required String playerId,
  });

  Stream<GrandPrixBet?> getBetByGrandPrixIdAndPlayerId({
    required String playerId,
    required String grandPrixId,
  });

  Future<void> addGrandPrixBets({
    required String playerId,
    required List<GrandPrixBet> grandPrixBets,
  });
}
