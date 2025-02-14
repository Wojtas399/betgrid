import 'package:betgrid/data/repository/season_driver/season_driver_repository.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonDriverRepository extends Mock
    implements SeasonDriverRepository {
  void mockGetAllFromSeason({
    required List<SeasonDriver> expectedSeasonDrivers,
  }) {
    when(
      () => getAllFromSeason(any()),
    ).thenAnswer((_) => Stream.value(expectedSeasonDrivers));
  }

  void mockGetById({SeasonDriver? expectedSeasonDriver}) {
    when(
      () => getById(
        season: any(named: 'season'),
        seasonDriverId: any(named: 'seasonDriverId'),
      ),
    ).thenAnswer((_) => Stream.value(expectedSeasonDriver));
  }
}
