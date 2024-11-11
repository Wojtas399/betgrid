import 'package:betgrid/data/repository/season_grand_prix/season_grand_prix_repository.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixRepository extends Mock
    implements SeasonGrandPrixRepository {
  void mockGetAllSeasonGrandPrixesFromSeason({
    required List<SeasonGrandPrix> expectedSeasonGrandPrixes,
  }) {
    when(
      () => getAllSeasonGrandPrixesFromSeason(any()),
    ).thenAnswer((_) => Stream.value(expectedSeasonGrandPrixes));
  }
}
