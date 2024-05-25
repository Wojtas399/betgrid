import 'package:betgrid/use_case/get_player_points_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPlayerPointsUseCase extends Mock
    implements GetPlayerPointsUseCase {
  void mock({
    double? points,
  }) {
    when(
      () => call(
        playerId: any(named: 'playerId'),
      ),
    ).thenAnswer((_) => Stream.value(points));
  }
}
