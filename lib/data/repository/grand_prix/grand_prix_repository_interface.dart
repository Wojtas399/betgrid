import '../../model/grand_prix.dart';

abstract interface class GrandPrixRepositoryInterface {
  Stream<List<GrandPrix>> getAllGrandPrixes();
}
