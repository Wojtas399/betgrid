import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixRepository extends Mock implements GrandPrixRepository {
  void mockLoadAllGrandPrixes(List<GrandPrix> grandPrixes) {
    when(loadAllGrandPrixes).thenAnswer((_) => Future.value(grandPrixes));
  }
}
