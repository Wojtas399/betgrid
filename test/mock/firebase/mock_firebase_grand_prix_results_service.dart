import 'package:betgrid/data/firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_grand_prix_results_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixResultsService extends Mock
    implements FirebaseGrandPrixResultsService {
  void mockFetchResultsForGrandPrix({GrandPrixResultsDto? grandPrixResultDto}) {
    when(
      () => fetchResultsForGrandPrix(
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixResultDto));
  }
}
