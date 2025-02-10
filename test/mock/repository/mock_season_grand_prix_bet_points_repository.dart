import 'package:betgrid/data/repository/season_grand_prix_bet_points/season_grand_prix_bet_points_repository.dart';
import 'package:betgrid/model/season_grand_prix_bet_points.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixBetPointsRepository extends Mock
    implements SeasonGrandPrixBetPointsRepository {
  void mockGetSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes({
    required List<SeasonGrandPrixBetPoints> seasonGrandPrixesBetPoints,
  }) {
    when(
      () => getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
        season: any(named: 'season'),
        idsOfPlayers: any(named: 'idsOfPlayers'),
        idsOfSeasonGrandPrixes: any(named: 'idsOfSeasonGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(seasonGrandPrixesBetPoints));
  }

  void mockGetSeasonGetGrandPrixBetPoints({
    SeasonGrandPrixBetPoints? seasonGrandPrixBetPoints,
  }) {
    when(
      () => getSeasonGrandPrixBetPoints(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(seasonGrandPrixBetPoints));
  }
}
