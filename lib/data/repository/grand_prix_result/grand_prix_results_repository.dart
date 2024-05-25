import '../../../model/grand_prix_results.dart';

abstract interface class GrandPrixResultsRepository {
  Stream<GrandPrixResults?> getGrandPrixResultsForGrandPrix({
    required String grandPrixId,
  });

  Stream<List<GrandPrixResults>> getGrandPrixResultsForGrandPrixes({
    required List<String> idsOfGrandPrixes,
  });
}
