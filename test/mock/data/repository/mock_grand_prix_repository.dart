import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixRepository extends Mock implements GrandPrixRepository {
  void mockGetAllGrandPrixes(List<GrandPrix> grandPrixes) {
    when(getAllGrandPrixes).thenAnswer((_) => Stream.value(grandPrixes));
  }

  void mockLoadGrandPrixById(GrandPrix? grandPrix) {
    when(
      () => loadGrandPrixById(
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrix));
  }
}
