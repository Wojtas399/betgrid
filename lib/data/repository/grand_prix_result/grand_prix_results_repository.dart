import '../../../model/grand_prix_results.dart';

abstract interface class GrandPrixResultsRepository {
  Stream<GrandPrixResults?> getGrandPrixResultsForSeasonGrandPrix({
    required String seasonGrandPrixId,
  });

  Stream<List<GrandPrixResults>> getGrandPrixResultsForSeasonGrandPrixes({
    required List<String> idsOfSeasonGrandPrixes,
  });
}
