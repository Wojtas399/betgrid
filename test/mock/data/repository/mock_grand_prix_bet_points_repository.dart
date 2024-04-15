import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetPointsRepository extends Mock
    implements GrandPrixBetPointsRepository {
  void mockGetPointsForPlayerByGrandPrixId({
    GrandPrixBetPoints? grandPrixBetPoints,
  }) {
    when(
      () => getPointsForPlayerByGrandPrixId(
        playerId: any(named: 'playerId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBetPoints));
  }
}
