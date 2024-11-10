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
    ).thenAnswer((_) => Future.value(expectedAddedGrandPrixBetDto));
  }

  void mockUpdateGrandPrixBet({
    GrandPrixBetDto? expectedUpdatedGrandPrixBetDto,
  }) {
    when(
      () => updateGrandPrixBet(
        userId: any(named: 'userId'),
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
    ).thenAnswer((_) => Future.value(expectedUpdatedGrandPrixBetDto));
  }
}
