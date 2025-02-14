import 'package:betgrid/ui/screen/stats/stats_creator/create_logged_user_points_for_drivers_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_for_driver.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateLoggedUserPointsForDriversStats extends Mock
    implements CreateLoggedUserPointsForDriversStats {
  void mock({required List<PointsForDriver> expectedPointsForDrivers}) {
    when(
      () => call(season: any(named: 'season')),
    ).thenAnswer((_) => Stream.value(expectedPointsForDrivers));
  }
}
