import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetRepository extends Mock
    implements GrandPrixBetRepository {
  void mockGetGrandPrixBetsForPlayersAndSeasonGrandPrixes({
    required List<GrandPrixBet> grandPrixBets,
  }) {
    when(
      () => getGrandPrixBetsForPlayersAndSeasonGrandPrixes(
        idsOfPlayers: any(named: 'idsOfPlayers'),
        idsOfSeasonGrandPrixes: any(named: 'idsOfSeasonGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBets));
  }

  void mockGetGrandPrixBetForPlayerAndSeasonGrandPrix({
    GrandPrixBet? grandPrixBet,
  }) {
    when(
      () => getGrandPrixBetForPlayerAndSeasonGrandPrix(
        playerId: any(named: 'playerId'),
        seasonGrandPrixId: any(named: 'seasonGrandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBet));
  }

  void mockAddGrandPrixBet() {
    when(
      () => addGrandPrixBet(
        playerId: any(named: 'playerId'),
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

  void mockUpdateGrandPrixBet() {
    when(
      () => updateGrandPrixBet(
        playerId: any(named: 'playerId'),
        grandPrixBetId: any(named: 'grandPrixBetId'),
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
