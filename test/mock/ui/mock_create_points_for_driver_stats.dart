import 'package:betgrid/ui/screen/stats/stats_creator/create_points_for_driver_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/player_points.dart';
import 'package:mocktail/mocktail.dart';

class MockCreatePointsForDriverStats extends Mock
    implements CreatePointsForDriverStats {
  void mock({
    required List<PlayerPoints> playersPoints,
  }) {
    when(
      () => call(
        season: any(named: 'season'),
        seasonDriverId: any(named: 'seasonDriverId'),
      ),
    ).thenAnswer((_) => Stream.value(playersPoints));
  }
}
