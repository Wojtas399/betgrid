import '../../../model/grand_prix_basic_info.dart';

abstract interface class GrandPrixBasicInfoRepository {
  Stream<Iterable<GrandPrixBasicInfo>> getAll();

  Stream<GrandPrixBasicInfo?> getById(String id);

  Future<void> add({required String name, required String countryAlpha2Code});

  Future<void> deleteById(String id);
}
