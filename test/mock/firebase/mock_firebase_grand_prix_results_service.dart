import 'package:betgrid/firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_results_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixResultsService extends Mock
    implements FirebaseGrandPrixResultsService {
  void mockLoadResultsForGrandPrix({GrandPrixResultsDto? grandPrixResultDto}) {
    when(
      () => loadResultsForGrandPrix(
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixResultDto));
  }
}
