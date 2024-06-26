import 'package:betgrid/ui/screen/stats/stats_creator/create_points_for_driver_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:mocktail/mocktail.dart';

class MockCreatePointsForDriverStats extends Mock
    implements CreatePointsForDriverStats {
  void mock({
    required List<PointsByDriverPlayerPoints> playersPointsForDriver,
  }) {
    when(
      () => call(
        driverId: any(named: 'driverId'),
      ),
    ).thenAnswer((_) => Stream.value(playersPointsForDriver));
  }
}
