import 'package:betgrid/data/repository/season_grand_prix_result/season_grand_prix_results_repository.dart';
import 'package:betgrid/model/season_grand_prix_results.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixResultsRepository extends Mock
    implements SeasonGrandPrixResultsRepository {
  void mockGetResultsForSeasonGrandPrix({
    SeasonGrandPrixResults? results,
  }) {
    when(
      () => getResultsForSeasonGrandPrix(
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(results));
  }

  void mockGetResultsForSeasonGrandPrixes({
    required List<SeasonGrandPrixResults> seasonGrandPrixesResults,
  }) {
    when(
      () => getResultsForSeasonGrandPrixes(
        season: any(named: 'season'),
        idsOfSeasonGrandPrixes: any(named: 'idsOfSeasonGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(seasonGrandPrixesResults));
  }
}
