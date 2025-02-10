import '../../../model/grand_prix_bet_points.dart';

abstract interface class GrandPrixBetPointsRepository {
  Stream<List<GrandPrixBetPoints>>
      getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes({
    required int season,
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  });

  Stream<GrandPrixBetPoints?> getGrandPrixBetPoints({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  });
}
