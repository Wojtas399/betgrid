import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGrandPrixesWithPointsUseCase extends Mock
    implements GetGrandPrixesWithPointsUseCase {
  void mock({
    required List<GrandPrixWithPoints> grandPrixesWithPoints,
  }) {
    when(
      () => call(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixesWithPoints));
  }
}
