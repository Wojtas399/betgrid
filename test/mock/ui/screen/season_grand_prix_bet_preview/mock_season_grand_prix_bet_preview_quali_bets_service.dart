import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_quali_bets_service.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixBetPreviewQualiBetsService extends Mock
    implements SeasonGrandPrixBetPreviewQualiBetsService {
  void mockGetQualiBets({required List<SingleDriverBet> expectedQualiBets}) {
    when(getQualiBets).thenAnswer((_) => Stream.value(expectedQualiBets));
  }
}
