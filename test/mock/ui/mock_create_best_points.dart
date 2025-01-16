import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_best_points.dart';
import 'package:betgrid/ui/screen/stats/stats_model/best_points.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateBestPoints extends Mock implements CreateBestPoints {
  MockCreateBestPoints() {
    registerFallbackValue(StatsType.grouped);
  }

  void mock({
    BestPoints? expectedBestPoints,
  }) {
    when(
      () => call(
        statsType: any(named: 'statsType'),
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Stream.value(expectedBestPoints));
  }
}
