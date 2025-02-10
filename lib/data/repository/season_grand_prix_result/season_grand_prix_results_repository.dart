import '../../../model/season_grand_prix_results.dart';

abstract interface class SeasonGrandPrixResultsRepository {
  Stream<SeasonGrandPrixResults?> getResultsForSeasonGrandPrix({
    required int season,
    required String seasonGrandPrixId,
  });

  Stream<List<SeasonGrandPrixResults>> getResultsForSeasonGrandPrixes({
    required int season,
    required List<String> idsOfSeasonGrandPrixes,
  });
}
