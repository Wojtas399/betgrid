import 'package:betgrid/data/firebase/model/season_driver_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_season_driver_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseSeasonDriverService extends Mock
    implements FirebaseSeasonDriverService {
  void mockFetchAllSeasonDriversFromSeason({
    required Iterable<SeasonDriverDto> expectedSeasonDriverDtos,
  }) {
    when(
      () => fetchAllSeasonDriversFromSeason(any()),
    ).thenAnswer((_) => Future.value(expectedSeasonDriverDtos));
  }

  void mockFetchSeasonDriverById({
    SeasonDriverDto? expectedSeasonDriverDto,
  }) {
    when(
      () => fetchSeasonDriverById(any()),
    ).thenAnswer((_) => Future.value(expectedSeasonDriverDto));
  }
}
