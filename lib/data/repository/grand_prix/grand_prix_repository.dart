import '../../../model/grand_prix.dart';

abstract interface class GrandPrixRepository {
  Stream<List<GrandPrix>?> getAllGrandPrixes();

  Stream<GrandPrix?> getGrandPrixById({required String grandPrixId});
}
