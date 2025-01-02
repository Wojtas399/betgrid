import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_grand_prix_bet_points_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixBetPointsService extends Mock
    implements FirebaseGrandPrixBetPointsService {
  void mockFetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId({
    GrandPrixBetPointsDto? grandPrixBetPointsDto,
  }) {
    when(
      () => fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId(
        playerId: any(named: 'playerId'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixBetPointsDto));
  }
}
