import 'package:betgrid/firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_bet_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeGrandPrixBetDto extends Fake implements GrandPrixBetDto {}

class MockFirebaseGrandPrixBetService extends Mock
    implements FirebaseGrandPrixBetService {
  MockFirebaseGrandPrixBetService() {
    registerFallbackValue(FakeGrandPrixBetDto());
  }

  void mockLoadAllGrandPrixBets(List<GrandPrixBetDto> grandPrixBetDtos) {
    when(
      () => loadAllGrandPrixBets(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixBetDtos));
  }

  void mockLoadGrandPrixBetByGrandPrixId(GrandPrixBetDto? grandPrixBetDto) {
    when(
      () => loadGrandPrixBetByGrandPrixId(
        userId: any(named: 'userId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Future.value(grandPrixBetDto));
  }

  void mockAddGrandPrixBet() {
    when(
      () => addGrandPrixBet(
        userId: any(named: 'userId'),
        grandPrixBetDto: any(named: 'grandPrixBetDto'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateGrandPrixBet(GrandPrixBetDto? updatedGrandPrixBetDto) {
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
    ).thenAnswer((_) => Future.value(updatedGrandPrixBetDto));
  }
}
