import 'package:betgrid/model/grand_prix_v2.dart';
import 'package:betgrid/use_case/get_grand_prix_based_on_season_grand_prix_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGrandPrixBasedOnSeasonGrandPrixUseCase extends Mock
    implements GetGrandPrixBasedOnSeasonGrandPrixUseCase {
  void mock({
    GrandPrixV2? expectedGrandPrix,
  }) {
    when(
      () => call(any()),
    ).thenAnswer((_) => Stream.value(expectedGrandPrix));
  }
}
