import '../../../model/grand_prix_results.dart';

abstract interface class GrandPrixResultsRepository {
  Stream<GrandPrixResults?> getResultForGrandPrix({
    required String grandPrixId,
  });
}
