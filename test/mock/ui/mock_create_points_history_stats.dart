import 'package:betgrid/ui/screen/stats/stats_creator/create_points_history_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:mocktail/mocktail.dart';

class MockCreatePointsHistoryStats extends Mock
    implements CreatePointsHistoryStats {
  void mock({
    PointsHistory? pointsHistory,
  }) {
    when(call).thenAnswer((_) => Stream.value(pointsHistory));
  }
}
