import 'package:betgrid/data/firebase/model/season_grand_prix_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_season_grand_prix_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseSeasonGrandPrixService extends Mock
    implements FirebaseSeasonGrandPrixService {
  void mockFetchAllSeasonGrandPrixesFromSeason({
    required List<SeasonGrandPrixDto> expectedSeasonGrandPrixDtos,
  }) {
    when(
      () => fetchAllSeasonGrandPrixesFromSeason(any()),
    ).thenAnswer((_) => Future.value(expectedSeasonGrandPrixDtos));
  }
}
