import '../../../model/season_grand_prix_bet_points.dart';

abstract interface class SeasonGrandPrixBetPointsRepository {
  Stream<List<SeasonGrandPrixBetPoints>> getForPlayersAndSeasonGrandPrixes({
    required int season,
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  });

  Stream<SeasonGrandPrixBetPoints?> getBySeasonGrandPrixId({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  });
}
