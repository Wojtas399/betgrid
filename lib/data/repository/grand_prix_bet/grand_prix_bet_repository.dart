import '../../../model/grand_prix_bet.dart';

abstract interface class GrandPrixBetRepository {
  Stream<List<GrandPrixBet>?> getAllGrandPrixBetsForPlayer({
    required String playerId,
  });

  Stream<List<GrandPrixBet>> getGrandPrixBetsForPlayersAndGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfGrandPrixes,
  });

  Stream<GrandPrixBet?> getGrandPrixBetForPlayerAndGrandPrix({
    required String playerId,
    required String grandPrixId,
  });

  Future<void> addGrandPrixBetsForPlayer({
    required String playerId,
    required List<GrandPrixBet> grandPrixBets,
  });
}
