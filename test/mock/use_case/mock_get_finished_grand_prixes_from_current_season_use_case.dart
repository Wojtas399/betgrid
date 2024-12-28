import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFinishedGrandPrixesFromCurrentSeasonUseCase extends Mock
    implements GetFinishedGrandPrixesFromCurrentSeasonUseCase {
  void mock({
    required List<SeasonGrandPrix> finishedSeasonGrandPrixes,
  }) {
    when(call).thenAnswer((_) => Stream.value(finishedSeasonGrandPrixes));
  }
}
