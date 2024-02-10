import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetRepository extends Mock
    implements GrandPrixBetRepository {
  void mockGetAllGrandPrixBets(List<GrandPrixBet>? grandPrixBets) {
    when(
      () => getAllGrandPrixBets(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBets));
  }

  void mockGetGrandPrixBetByGrandPrixId(GrandPrixBet? grandPrixBet) {
    when(
      () => getGrandPrixBetByGrandPrixId(
        userId: any(named: 'userId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBet));
  }

  void mockAddGrandPrixBets() {
    when(
      () => addGrandPrixBets(
        userId: any(named: 'userId'),
        grandPrixBets: any(named: 'grandPrixBets'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
