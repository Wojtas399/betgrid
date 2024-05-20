import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixResultsRepository extends Mock
    implements GrandPrixResultsRepository {
  void mockGetGrandPrixResultsForGrandPrix({GrandPrixResults? results}) {
    when(
      () => getGrandPrixResultsForGrandPrix(
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(results));
  }

  void mockGetGrandPrixResultsForGrandPrixes({
    required List<GrandPrixResults> grandPrixesResults,
  }) {
    when(
      () => getGrandPrixResultsForGrandPrixes(
        idsOfGrandPrixes: any(named: 'idsOfGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixesResults));
  }
}
