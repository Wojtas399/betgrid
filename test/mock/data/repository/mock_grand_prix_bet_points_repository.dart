import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetPointsRepository extends Mock
    implements GrandPrixBetPointsRepository {
  void mockGetGrandPrixBetPointsForPlayersAndGrandPrixes({
    required List<GrandPrixBetPoints> grandPrixesBetPoints,
  }) {
    when(
      () => getGrandPrixBetPointsForPlayersAndGrandPrixes(
        idsOfPlayers: any(named: 'idsOfPlayers'),
        idsOfGrandPrixes: any(named: 'idsOfGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixesBetPoints));
  }

  void mockGetGrandPrixBetPointsForPlayerAndGrandPrix({
    GrandPrixBetPoints? grandPrixBetPoints,
  }) {
    when(
      () => getGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: any(named: 'playerId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBetPoints));
  }
}
