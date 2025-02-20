import 'package:betgrid/ui/screen/season_grand_prix_bets/cubit/season_grand_prix_bets_gp_status_service.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bets/cubit/season_grand_prix_bets_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixBetsGpStatusService extends Mock
    implements SeasonGrandPrixBetsGpStatusService {
  void mockDefineStatusForGp({
    required SeasonGrandPrixStatus expectedGpStatus,
  }) {
    when(
      () => defineStatusForGp(
        gpStartDateTime: any(named: 'gpStartDateTime'),
        gpEndDateTime: any(named: 'gpEndDateTime'),
        now: any(named: 'now'),
      ),
    ).thenReturn(expectedGpStatus);
  }
}
