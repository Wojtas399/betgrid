import 'package:betgrid/ui/screen/season_grand_prix_bet/preview/cubit/season_grand_prix_bet_preview_state.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet/preview/cubit/season_grand_prix_bet_preview_status_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixBetPreviewStatusService extends Mock
    implements SeasonGrandPrixBetPreviewStatusService {
  void mockSelectStatusBasedOnPoints({required BetStatus expectedStatus}) {
    when(() => selectStatusBasedOnPoints(any())).thenReturn(expectedStatus);
  }
}
