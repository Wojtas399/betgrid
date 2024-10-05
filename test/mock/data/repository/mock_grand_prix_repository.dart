import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixRepository extends Mock implements GrandPrixRepository {
  void mockGetAllGrandPrixesFromSeason({
    List<GrandPrix>? expectedGrandPrixes,
  }) {
    when(
      () => getAllGrandPrixesFromSeason(any()),
    ).thenAnswer((_) => Stream.value(expectedGrandPrixes));
  }

  void mockGetGrandPrixByIdFromSeason({
    GrandPrix? expectedGrandPrix,
  }) {
    when(
      () => getGrandPrixByIdFromSeason(
        season: any(named: 'season'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(expectedGrandPrix));
  }
}
