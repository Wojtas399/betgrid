import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_from_season_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFinishedGrandPrixesFromSeasonUseCase extends Mock
    implements GetFinishedGrandPrixesFromSeasonUseCase {
  void mock({
    required List<SeasonGrandPrix> finishedSeasonGrandPrixes,
  }) {
    when(
      () => call(
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Stream.value(finishedSeasonGrandPrixes));
  }
}
