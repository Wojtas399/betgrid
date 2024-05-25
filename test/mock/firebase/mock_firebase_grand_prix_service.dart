import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixService extends Mock
    implements FirebaseGrandPrixService {
  void mockFetchAllGrandPrixes({required List<GrandPrixDto> grandPrixDtos}) {
    when(fetchAllGrandPrixes).thenAnswer((_) => Future.value(grandPrixDtos));
  }

  void mockFetchGrandPrixById(GrandPrixDto? grandPrixDto) {
    when(
      () => fetchGrandPrixById(
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixDto));
  }
}
