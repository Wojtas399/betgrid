import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/use_case/get_grand_prix_based_on_season_grand_prix_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGrandPrixBasedOnSeasonGrandPrixUseCase extends Mock
    implements GetGrandPrixBasedOnSeasonGrandPrixUseCase {
  void mock({
    GrandPrix? expectedGrandPrix,
  }) {
    when(
      () => call(any()),
    ).thenAnswer((_) => Stream.value(expectedGrandPrix));
  }
}
