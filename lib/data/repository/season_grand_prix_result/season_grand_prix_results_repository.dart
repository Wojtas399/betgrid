import '../../../model/season_grand_prix_results.dart';

abstract interface class SeasonGrandPrixResultsRepository {
  Stream<SeasonGrandPrixResults?> getForSeasonGrandPrix({
    required int season,
    required String seasonGrandPrixId,
  });
}
