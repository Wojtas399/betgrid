import 'package:betgrid_shared/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_bet_points_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixBetPointsService extends Mock
    implements FirebaseGrandPrixBetPointsService {
  void mockFetchGrandPrixBetPoints({
    GrandPrixBetPointsDto? grandPrixBetPointsDto,
  }) {
    when(
      () => fetchGrandPrixBetPoints(
        userId: any(named: 'userId'),
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixBetPointsDto));
  }
}
