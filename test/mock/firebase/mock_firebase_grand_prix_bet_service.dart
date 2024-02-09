import 'package:betgrid/firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import 'package:betgrid/firebase/service/firebase_grand_prix_bet_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeGrandPrixBetDto extends Fake implements GrandPrixBetDto {}

class MockFirebaseGrandPrixBetService extends Mock
    implements FirebaseGrandPrixBetService {
  MockFirebaseGrandPrixBetService() {
    registerFallbackValue(FakeGrandPrixBetDto());
  }

  void mockAddGrandPrixBet() {
    when(
      () => addGrandPrixBet(
        userId: any(named: 'userId'),
        grandPrixBetDto: any(named: 'grandPrixBetDto'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
