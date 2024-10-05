import '../../../model/grand_prix.dart';

abstract interface class GrandPrixRepository {
  Stream<List<GrandPrix>?> getAllGrandPrixesFromSeason(int season);

  Stream<GrandPrix?> getGrandPrixByIdFromSeason({
    required int season,
    required String grandPrixId,
  });
}
