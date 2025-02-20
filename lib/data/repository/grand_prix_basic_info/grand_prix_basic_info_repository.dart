import '../../../model/grand_prix_basic_info.dart';

abstract interface class GrandPrixBasicInfoRepository {
  Stream<GrandPrixBasicInfo?> getGrandPrixBasicInfoById(String id);
}
