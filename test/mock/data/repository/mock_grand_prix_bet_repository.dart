import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetRepository extends Mock
    implements GrandPrixBetRepository {
  void mockGetAllGrandPrixBetsForPlayer({List<GrandPrixBet>? grandPrixBets}) {
    when(
      () => getAllGrandPrixBetsForPlayer(
        playerId: any(named: 'playerId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBets));
  }

  void mockGetBetByGrandPrixIdAndPlayerId(GrandPrixBet? grandPrixBet) {
    when(
      () => getBetByGrandPrixIdAndPlayerId(
        playerId: any(named: 'playerId'),
        grandPrixId: any(named: 'grandPrixId'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixBet));
  }

  void mockAddGrandPrixBets() {
    when(
      () => addGrandPrixBets(
        playerId: any(named: 'playerId'),
        grandPrixBets: any(named: 'grandPrixBets'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
