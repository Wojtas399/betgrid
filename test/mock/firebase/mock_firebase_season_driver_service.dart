import 'package:betgrid/data/firebase/model/season_driver_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_season_driver_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseSeasonDriverService extends Mock
    implements FirebaseSeasonDriverService {
  void mockFetchAllDriversFromSeason({
    required Iterable<SeasonDriverDto> expectedSeasonDriverDtos,
  }) {
    when(
      () => fetchAllDriversFromSeason(any()),
    ).thenAnswer((_) => Future.value(expectedSeasonDriverDtos));
  }
}
