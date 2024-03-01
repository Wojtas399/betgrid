import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixResultsRepository extends Mock
    implements GrandPrixResultsRepository {
  void mockGetResultsForGrandPrix({GrandPrixResults? results}) {
    when(
      () => getResultForGrandPrix(
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(results));
  }
}
