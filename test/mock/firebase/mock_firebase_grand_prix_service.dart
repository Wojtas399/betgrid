import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixService extends Mock
    implements FirebaseGrandPrixService {
  void mockLoadAllGrandPrixes({required List<GrandPrixDto> grandPrixDtos}) {
    when(loadAllGrandPrixes).thenAnswer((_) => Future.value(grandPrixDtos));
  }
}
