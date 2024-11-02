import 'package:betgrid/data/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_grand_prix_bet_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeGrandPrixBetDto extends Fake implements GrandPrixBetDto {}

class MockFirebaseGrandPrixBetService extends Mock
    implements FirebaseGrandPrixBetService {
  MockFirebaseGrandPrixBetService() {
    registerFallbackValue(FakeGrandPrixBetDto());
  }

  void mockFetchGrandPrixBetByGrandPrixId(GrandPrixBetDto? grandPrixBetDto) {
    when(
      () => fetchGrandPrixBetByGrandPrixId(
        playerId: any(named: 'playerId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixBetDto));
  }

  void mockAddGrandPrixBet({
    GrandPrixBetDto? expectedAddedGrandPrixBetDto,
  }) {
    when(
      () => addGrandPrixBet(
        userId: any(named: 'userId'),
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
    ).thenAnswer((_) => Future.value(expectedAddedGrandPrixBetDto));
  }

  void mockUpdateGrandPrixBet({
    GrandPrixBetDto? expectedUpdatedGrandPrixBetDto,
  }) {
    when(
      () => updateGrandPrixBet(
        userId: any(named: 'userId'),
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
    ).thenAnswer((_) => Future.value(expectedUpdatedGrandPrixBetDto));
  }
}
