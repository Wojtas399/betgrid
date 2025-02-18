import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_race_bets_service.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonGrandPrixBetPreviewRaceBetsService extends Mock
    implements SeasonGrandPrixBetPreviewRaceBetsService {
  void mockGetPodiumBets({required List<SingleDriverBet> expectedPodiumBets}) {
    when(getPodiumBets).thenAnswer((_) => Stream.value(expectedPodiumBets));
  }

  void mockGetP10Bet({required SingleDriverBet expectedP10Bet}) {
    when(getP10Bet).thenAnswer((_) => Stream.value(expectedP10Bet));
  }

  void mockGetFastestLapBet({required SingleDriverBet expectedFastestLapBet}) {
    when(
      getFastestLapBet,
    ).thenAnswer((_) => Stream.value(expectedFastestLapBet));
  }

  void mockGetDnfDriversBet({
    required MultipleDriversBet expectedDnfDriversBet,
  }) {
    when(
      getDnfDriversBet,
    ).thenAnswer((_) => Stream.value(expectedDnfDriversBet));
  }

  void mockGetSafetyCarBet({required BooleanBet expectedSafetyCarBet}) {
    when(getSafetyCarBet).thenAnswer((_) => Stream.value(expectedSafetyCarBet));
  }

  void mockGetRedFlagBet({required BooleanBet expectedRedFlagBet}) {
    when(getRedFlagBet).thenAnswer((_) => Stream.value(expectedRedFlagBet));
  }
}
