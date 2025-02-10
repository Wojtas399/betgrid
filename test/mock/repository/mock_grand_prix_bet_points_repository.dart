import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetPointsRepository extends Mock
    implements GrandPrixBetPointsRepository {
  void mockGetGrandPrixBetPointsForPlayersAndSeasonGrandPrixes({
    required List<GrandPrixBetPoints> grandPrixesBetPoints,
  }) {
    when(
      () => getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
        season: any(named: 'season'),
        idsOfPlayers: any(named: 'idsOfPlayers'),
        idsOfSeasonGrandPrixes: any(named: 'idsOfSeasonGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixesBetPoints));
  }

  void mockGetGrandPrixBetPoints({
    GrandPrixBetPoints? grandPrixBetPoints,
  }) {
    when(
      () => getGrandPrixBetPoints(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBetPoints));
  }
}
