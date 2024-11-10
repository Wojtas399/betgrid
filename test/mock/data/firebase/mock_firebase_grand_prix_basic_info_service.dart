import 'package:betgrid/data/firebase/model/grand_prix_basic_info_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_grand_prix_basic_info_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixBasicInfoService extends Mock
    implements FirebaseGrandPrixBasicInfoService {
  void mockFetchGrandPrixBasicInfoById({
    GrandPrixBasicInfoDto? expectedGrandPrixBasicInfoDto,
  }) {
    when(
      () => fetchGrandPrixBasicInfoById(
        any(),
      ),
    ).thenAnswer((_) => Future.value(expectedGrandPrixBasicInfoDto));
  }
}
