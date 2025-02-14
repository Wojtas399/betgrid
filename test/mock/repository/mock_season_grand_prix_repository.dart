import 'package:betgrid/data/repository/season_grand_prix/season_grand_prix_repository.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixRepository extends Mock
    implements SeasonGrandPrixRepository {
  void mockGetAllFromSeason({
    required List<SeasonGrandPrix> expectedSeasonGrandPrixes,
  }) {
    when(
      () => getAllFromSeason(any()),
    ).thenAnswer((_) => Stream.value(expectedSeasonGrandPrixes));
  }

  void mockGetById({SeasonGrandPrix? expectedSeasonGrandPrix}) {
    when(
      () => getById(
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value((expectedSeasonGrandPrix)));
  }
}
