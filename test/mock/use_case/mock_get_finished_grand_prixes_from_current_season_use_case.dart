import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFinishedGrandPrixesFromCurrentSeasonUseCase extends Mock
    implements GetFinishedGrandPrixesFromCurrentSeasonUseCase {
  void mock({
    required List<GrandPrix> finishedGrandPrixes,
  }) {
    when(call).thenAnswer((_) => Stream.value(finishedGrandPrixes));
  }
}
