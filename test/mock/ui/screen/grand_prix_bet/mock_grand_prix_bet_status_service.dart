import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_status_service.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetStatusService extends Mock
    implements GrandPrixBetStatusService {
  void mockSelectStatusBasedOnPoints({
    required BetStatus expectedStatus,
  }) {
    when(
      () => selectStatusBasedOnPoints(any()),
    ).thenReturn(expectedStatus);
  }
}
