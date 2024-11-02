import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetRepository extends Mock
    implements GrandPrixBetRepository {
  void mockGetGrandPrixBetsForPlayersAndGrandPrixes({
    required List<GrandPrixBet> grandPrixBets,
  }) {
    when(
      () => getGrandPrixBetsForPlayersAndGrandPrixes(
        idsOfPlayers: any(named: 'idsOfPlayers'),
        idsOfGrandPrixes: any(named: 'idsOfGrandPrixes'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBets));
  }

  void mockGetGrandPrixBetForPlayerAndGrandPrix({
    GrandPrixBet? grandPrixBet,
  }) {
    when(
      () => getGrandPrixBetForPlayerAndGrandPrix(
        playerId: any(named: 'playerId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBet));
  }

  void mockAddGrandPrixBet() {
    when(
      () => addGrandPrixBet(
        playerId: any(named: 'playerId'),
        grandPrixId: any(named: 'grandPrixId'),
        qualiStandingsByDriverIds: any(named: 'qualiStandingsByDriverIds'),
        p1DriverId: any(named: 'p1DriverId'),
        p2DriverId: any(named: 'p2DriverId'),
        p3DriverId: any(named: 'p3DriverId'),
        p10DriverId: any(named: 'p10DriverId'),
        fastestLapDriverId: any(named: 'fastestLapDriverId'),
        dnfDriverIds: any(named: 'dnfDriverIds'),
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
        qualiStandingsByDriverIds: any(named: 'qualiStandingsByDriverIds'),
        p1DriverId: any(named: 'p1DriverId'),
        p2DriverId: any(named: 'p2DriverId'),
        p3DriverId: any(named: 'p3DriverId'),
        p10DriverId: any(named: 'p10DriverId'),
        fastestLapDriverId: any(named: 'fastestLapDriverId'),
        dnfDriverIds: any(named: 'dnfDriverIds'),
        willBeSafetyCar: any(named: 'willBeSafetyCar'),
        willBeRedFlag: any(named: 'willBeRedFlag'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
