import '../../../model/season_grand_prix_bet_points.dart';

abstract interface class SeasonGrandPrixBetPointsRepository {
  Stream<List<SeasonGrandPrixBetPoints>>
      getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes({
    required int season,
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  });

  Stream<SeasonGrandPrixBetPoints?> getSeasonGrandPrixBetPoints({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  });
}
