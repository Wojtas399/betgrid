import '../../../model/grand_prix.dart';

abstract interface class GrandPrixRepository {
  Stream<List<GrandPrix>> getAllGrandPrixes();
}
