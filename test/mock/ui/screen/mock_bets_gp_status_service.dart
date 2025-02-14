import 'package:betgrid/ui/screen/bets/cubit/bets_gp_status_service.dart';
import 'package:betgrid/ui/screen/bets/cubit/bets_state.dart';
import 'package:mocktail/mocktail.dart';

class MockBetsGpStatusService extends Mock implements BetsGpStatusService {
  void mockDefineStatusForGp({required GrandPrixStatus expectedGpStatus}) {
    when(
      () => defineStatusForGp(
        gpStartDateTime: any(named: 'gpStartDateTime'),
        gpEndDateTime: any(named: 'gpEndDateTime'),
        now: any(named: 'now'),
      ),
    ).thenReturn(expectedGpStatus);
  }
}
