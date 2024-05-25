import 'package:betgrid/ui/screen/stats/stats_maker/points_history_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:mocktail/mocktail.dart';

class MockPointsHistoryMaker extends Mock implements PointsHistoryMaker {
  void mockPrepareStats({
    required PointsHistory pointsHistory,
  }) {
    when(
      () => prepareStats(
        players: any(named: 'players'),
        finishedGrandPrixes: any(named: 'finishedGrandPrixes'),
        grandPrixBetsPoints: any(named: 'grandPrixBetsPoints'),
      ),
    ).thenReturn(pointsHistory);
  }
}
