import 'package:betgrid/data/repository/season_driver/season_driver_repository.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonDriverRepository extends Mock
    implements SeasonDriverRepository {
  void mockGetAllSeasonDriversFromSeason({
    required List<SeasonDriver> expectedSeasonDrivers,
  }) {
    when(
      () => getAllSeasonDriversFromSeason(any()),
    ).thenAnswer((_) => Stream.value(expectedSeasonDrivers));
  }

  void mockGetSeasonDriverById({
    SeasonDriver? expectedSeasonDriver,
  }) {
    when(
      () => getSeasonDriverById(any()),
    ).thenAnswer((_) => Stream.value(expectedSeasonDriver));
  }
}
