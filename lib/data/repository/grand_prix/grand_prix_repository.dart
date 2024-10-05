import '../../../model/grand_prix.dart';

abstract interface class GrandPrixRepository {
  Stream<List<GrandPrix>?> getAllGrandPrixesFromSeason(int season);

  Stream<GrandPrix?> getGrandPrixById({
    required String grandPrixId,
  });
}
