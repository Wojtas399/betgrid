import 'package:betgrid/ui/screen/stats/stats_maker/points_history_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:mocktail/mocktail.dart';

class MockPointsHistoryMaker extends Mock implements PointsHistoryMaker {
  void mock({
    PointsHistory? pointsHistory,
  }) {
    when(call).thenAnswer((_) => Stream.value(pointsHistory));
  }
}
