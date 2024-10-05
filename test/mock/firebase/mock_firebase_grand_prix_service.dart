import 'package:betgrid/data/firebase/model/grand_prix_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_grand_prix_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixService extends Mock
    implements FirebaseGrandPrixService {
  void mockFetchAllGrandPrixesFromSeason({
    required List<GrandPrixDto> expectedGrandPrixDtos,
  }) {
    when(
      () => fetchAllGrandPrixesFromSeason(any()),
    ).thenAnswer((_) => Future.value(expectedGrandPrixDtos));
  }

  void mockFetchGrandPrixFromSeasonById({
    GrandPrixDto? expectedGrandPrixDto,
  }) {
    when(
      () => fetchGrandPrixFromSeasonById(
        season: any(named: 'season'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(expectedGrandPrixDto));
  }
}
