import 'package:betgrid/data/repository/season_driver/season_driver_repository.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonDriverRepository extends Mock
    implements SeasonDriverRepository {
  void mockGetSeasonDriverByDriverIdAndSeason({
    SeasonDriver? expectedSeasonDriver,
  }) {
    when(
      () => getSeasonDriverByDriverIdAndSeason(
        driverId: any(named: 'driverId'),
        season: any(named: 'season'),
      ),
    ).thenAnswer((_) => Stream.value(expectedSeasonDriver));
  }
}
