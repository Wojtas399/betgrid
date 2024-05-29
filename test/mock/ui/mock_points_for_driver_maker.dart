import 'package:betgrid/ui/screen/stats/stats_maker/points_for_driver_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:mocktail/mocktail.dart';

class MockPointsForDriverMaker extends Mock implements PointsForDriverMaker {
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
