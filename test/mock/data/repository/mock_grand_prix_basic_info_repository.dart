import 'package:betgrid/data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBasicInfoRepository extends Mock
    implements GrandPrixBasicInfoRepository {
  void mockGetGrandPrixBasicInfoById({
    GrandPrixBasicInfo? expectedGrandPrixBasicInfo,
  }) {
    when(
      () => getGrandPrixBasicInfoById(any()),
    ).thenAnswer((_) => Stream.value(expectedGrandPrixBasicInfo));
  }
}
