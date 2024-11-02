import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_quali_bets_service.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetQualiBetsService extends Mock
    implements GrandPrixBetQualiBetsService {
  void mockGetQualiBets({
    required List<SingleDriverBet> expectedQualiBets,
  }) {
    when(getQualiBets).thenAnswer((_) => Stream.value(expectedQualiBets));
  }
}
