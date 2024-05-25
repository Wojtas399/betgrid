import '../../../model/grand_prix_bet_points.dart';

abstract interface class GrandPrixBetPointsRepository {
  Stream<List<GrandPrixBetPoints>>
      getGrandPrixBetPointsForPlayersAndGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfGrandPrixes,
  });

  Stream<GrandPrixBetPoints?> getGrandPrixBetPointsForPlayerAndGrandPrix({
    required String playerId,
    required String grandPrixId,
  });
}
