import '../../../model/grand_prix_bet.dart';

abstract interface class GrandPrixBetRepository {
  Stream<List<GrandPrixBet>?> getAllGrandPrixBetsForPlayer({
    required String playerId,
  });

  Stream<List<GrandPrixBet>> getGrandPrixBetsForPlayers({
    required List<String> idsOfPlayers,
    required List<String> idsOfGrandPrixes,
  });

  Stream<GrandPrixBet?> getGrandPrixBetByGrandPrixIdAndPlayerId({
    required String playerId,
    required String grandPrixId,
  });

  Future<void> addGrandPrixBetsForPlayer({
    required String playerId,
    required List<GrandPrixBet> grandPrixBets,
  });
}
