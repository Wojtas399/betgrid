import 'package:betgrid/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_bet_points_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseGrandPrixBetPointsService extends Mock
    implements FirebaseGrandPrixBetPointsService {
  void mockLoadGrandPrixBetPointsByPlayerIdAndGrandPrixId({
    GrandPrixBetPointsDto? grandPrixBetPointsDto,
  }) {
    when(
      () => loadGrandPrixBetPointsByPlayerIdAndGrandPrixId(
        playerId: any(named: 'playerId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixBetPointsDto));
  }
}
