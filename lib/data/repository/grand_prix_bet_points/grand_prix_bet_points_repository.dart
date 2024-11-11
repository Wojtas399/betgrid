import '../../../model/grand_prix_bet_points.dart';

abstract interface class GrandPrixBetPointsRepository {
  Stream<List<GrandPrixBetPoints>>
      getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  });

  Stream<GrandPrixBetPoints?> getGrandPrixBetPointsForPlayerAndSeasonGrandPrix({
    required String playerId,
    required String seasonGrandPrixId,
  });
}
