import 'package:betgrid/data/firebase/model/grand_prix_results_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_grand_prix_results_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixResultsService extends Mock
    implements FirebaseGrandPrixResultsService {
  void mockFetchResultsForSeasonGrandPrix({
    GrandPrixResultsDto? grandPrixResultDto,
  }) {
    when(
      () => fetchResultsForSeasonGrandPrix(
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixResultDto));
  }
}
