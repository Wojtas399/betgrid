import 'package:betgrid/data/repository/season_grand_prix_bet/season_grand_prix_bet_repository.dart';
import 'package:betgrid/model/season_grand_prix_bet.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixBetRepository extends Mock
    implements SeasonGrandPrixBetRepository {
  void mockGetSeasonGrandPrixBet({SeasonGrandPrixBet? seasonGrandPrixBet}) {
    when(
      () => getSeasonGrandPrixBet(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(seasonGrandPrixBet));
  }

  void mockAddSeasonGrandPrixBet() {
    when(
      () => addSeasonGrandPrixBet(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
        qualiStandingsBySeasonDriverIds: any(
          named: 'qualiStandingsBySeasonDriverIds',
        ),
        p1SeasonDriverId: any(named: 'p1SeasonDriverId'),
        p2SeasonDriverId: any(named: 'p2SeasonDriverId'),
        p3SeasonDriverId: any(named: 'p3SeasonDriverId'),
        p10SeasonDriverId: any(named: 'p10SeasonDriverId'),
        fastestLapSeasonDriverId: any(named: 'fastestLapSeasonDriverId'),
        dnfSeasonDriverIds: any(named: 'dnfSeasonDriverIds'),
        willBeSafetyCar: any(named: 'willBeSafetyCar'),
        willBeRedFlag: any(named: 'willBeRedFlag'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateSeasonGrandPrixBet() {
    when(
      () => updateSeasonGrandPrixBet(
        playerId: any(named: 'playerId'),
        season: any(named: 'season'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
        qualiStandingsBySeasonDriverIds: any(
          named: 'qualiStandingsBySeasonDriverIds',
        ),
        p1SeasonDriverId: any(named: 'p1SeasonDriverId'),
        p2SeasonDriverId: any(named: 'p2SeasonDriverId'),
        p3SeasonDriverId: any(named: 'p3SeasonDriverId'),
        p10SeasonDriverId: any(named: 'p10SeasonDriverId'),
        fastestLapSeasonDriverId: any(named: 'fastestLapSeasonDriverId'),
        dnfSeasonDriverIds: any(named: 'dnfSeasonDriverIds'),
        willBeSafetyCar: any(named: 'willBeSafetyCar'),
        willBeRedFlag: any(named: 'willBeRedFlag'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
