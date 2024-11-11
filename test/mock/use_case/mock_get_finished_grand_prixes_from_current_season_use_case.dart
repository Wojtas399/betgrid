import 'package:betgrid/model/grand_prix_v2.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFinishedGrandPrixesFromCurrentSeasonUseCase extends Mock
    implements GetFinishedGrandPrixesFromCurrentSeasonUseCase {
  void mock({
    required List<GrandPrixV2> finishedGrandPrixes,
  }) {
    when(call).thenAnswer((_) => Stream.value(finishedGrandPrixes));
  }
}
