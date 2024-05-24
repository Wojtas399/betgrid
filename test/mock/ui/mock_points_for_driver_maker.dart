import 'package:betgrid/ui/screen/stats/stats_maker/points_for_driver_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:mocktail/mocktail.dart';

class MockPointsForDriverMaker extends Mock implements PointsForDriverMaker {
  void mockPrepareStats({
    required List<PointsByDriverPlayerPoints> playersPointsForDriver,
  }) {
    when(
      () => prepareStats(
        driverId: any(named: 'driverId'),
        players: any(named: 'players'),
        grandPrixesIds: any(named: 'grandPrixesIds'),
        grandPrixesResults: any(named: 'grandPrixesResults'),
        grandPrixesBetPoints: any(named: 'grandPrixesBetPoints'),
        grandPrixesBets: any(named: 'grandPrixesBets'),
      ),
    ).thenReturn(playersPointsForDriver);
  }
}
