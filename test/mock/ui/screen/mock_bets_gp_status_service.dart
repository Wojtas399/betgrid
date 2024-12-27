import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/screen/bets/cubit/bets_gp_status_service.dart';
import 'package:betgrid/ui/screen/bets/cubit/bets_state.dart';
import 'package:mocktail/mocktail.dart';

class MockBetsGpStatusService extends Mock implements BetsGpStatusService {
  MockBetsGpStatusService() {
    registerFallbackValue(
      GrandPrix(
        seasonGrandPrixId: '1',
        countryAlpha2Code: 'US',
        roundNumber: 1,
        name: 'GP',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 2),
      ),
    );
  }

  void mockDefineStatusForGp({
    required GrandPrixStatus expectedGpStatus,
  }) {
    when(
      () => defineStatusForGp(
        gp: any(named: 'gp'),
        now: any(named: 'now'),
      ),
    ).thenReturn(expectedGpStatus);
  }
}
