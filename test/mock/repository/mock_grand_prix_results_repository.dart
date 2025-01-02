import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixResultsRepository extends Mock
    implements GrandPrixResultsRepository {
  void mockGetGrandPrixResultsForSeasonGrandPrix({
    GrandPrixResults? results,
  }) {
    when(
      () => getGrandPrixResultsForSeasonGrandPrix(
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(results));
  }

  void mockGetGrandPrixResultsForSeasonGrandPrixes({
    required List<GrandPrixResults> grandPrixesResults,
  }) {
    when(
      () => getGrandPrixResultsForSeasonGrandPrixes(
        idsOfSeasonGrandPrixes: any(named: 'idsOfSeasonGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixesResults));
  }
}
