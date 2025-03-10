import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/model/season_grand_prix_bet_points.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_cubit.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_quali_bets_service.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/season_grand_prix_bet_creator.dart';
import '../../../creator/season_grand_prix_results_creator.dart';
import '../../../creator/quali_bet_points_creator.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_points_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_results_repository.dart';
import '../../../mock/ui/screen/season_grand_prix_bet_preview/mock_season_grand_prix_bet_preview_status_service.dart';
import '../../../mock/use_case/mock_get_details_for_all_drivers_from_season_use_case.dart';

void main() {
  final seasonGrandPrixBetRepository = MockSeasonGrandPrixBetRepository();
  final seasonGrandPrixResultsRepository =
      MockSeasonGrandPrixResultsRepository();
  final getDetailsOfAllDriversFromSeasonUseCase =
      MockGetDetailsOfAllDriversFromSeasonUseCase();
  final seasonGrandPrixBetPointsRepository =
      MockSeasonGrandPrixBetPointsRepository();
  final grandPrixBetStatusService =
      MockSeasonGrandPrixBetPreviewStatusService();
  const String playerId = 'p1';
  const int season = 2024;
  const String seasonGrandPrixId = 'gp1';
  final service = SeasonGrandPrixBetPreviewQualiBetsService(
    seasonGrandPrixBetRepository,
    seasonGrandPrixResultsRepository,
    getDetailsOfAllDriversFromSeasonUseCase,
    seasonGrandPrixBetPointsRepository,
    grandPrixBetStatusService,
    const GrandPrixBetCubitParams(
      playerId: playerId,
      season: season,
      seasonGrandPrixId: seasonGrandPrixId,
    ),
  );

  test('should create list with 20 SingleDriverBet elements where each element '
      'has data corresponding to its position', () async {
    final List<DriverDetails> allDriverDetails = List.generate(
      20,
      (int driverIndex) =>
          DriverDetailsCreator(seasonDriverId: 'd${driverIndex + 1}').create(),
    );
    final List<String?> betQualiStandingsBySeasonDriverIds = List.generate(
      20,
      (int positionIndex) => switch (positionIndex) {
        0 => 'd1',
        4 => 'd5',
        5 => 'd6',
        9 => 'd9',
        12 => 'd13',
        17 => 'd18',
        19 => 'd8',
        _ => null,
      },
    );
    final List<String> resultQualiStandingsBySeasonDriverIds = [
      'd1',
      'd3',
      'd4',
      'd19',
      'd5',
      'd6',
      'd7',
      'd8',
      'd9',
      'd2',
      'd10',
      'd11',
      'd13',
      'd12',
      'd15',
      'd14',
      'd18',
      'd16',
      'd17',
      'd20',
    ];
    final QualiBetPoints qualiBetPoints =
        const QualiBetPointsCreator(
          q3P1: 1,
          q3P2: 0,
          q3P3: 0,
          q3P4: 0,
          q3P5: 2,
          q3P6: 2,
          q3P7: 0,
          q3P8: 0,
          q3P9: 0,
          q3P10: 0,
          q2P11: 0,
          q2P12: 0,
          q2P13: 2,
          q2P14: 0,
          q2P15: 0,
          q1P16: 0,
          q1P17: 0,
          q1P18: 0,
          q1P19: 0,
          q1P20: 0,
        ).create();
    final List<SingleDriverBet> expectedBets = [
      SingleDriverBet(
        status: BetStatus.win,
        betDriver: allDriverDetails.first,
        resultDriver: allDriverDetails.first,
        points: 1,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[2],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[3],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[18],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.win,
        betDriver: allDriverDetails[4],
        resultDriver: allDriverDetails[4],
        points: 2,
      ),
      SingleDriverBet(
        status: BetStatus.win,
        betDriver: allDriverDetails[5],
        resultDriver: allDriverDetails[5],
        points: 2,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[6],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[7],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[8],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: allDriverDetails[8],
        resultDriver: allDriverDetails[1],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[9],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[10],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.win,
        betDriver: allDriverDetails[12],
        resultDriver: allDriverDetails[12],
        points: 2,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[11],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[14],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[13],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[17],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: allDriverDetails[17],
        resultDriver: allDriverDetails[15],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: null,
        resultDriver: allDriverDetails[16],
        points: 0,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: allDriverDetails[7],
        resultDriver: allDriverDetails[19],
        points: 0,
      ),
    ];
    seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet(
      seasonGrandPrixBet:
          SeasonGrandPrixBetCreator(
            qualiStandingsBySeasonDriverIds: betQualiStandingsBySeasonDriverIds,
          ).create(),
    );
    seasonGrandPrixResultsRepository.mockGetResultsForSeasonGrandPrix(
      results:
          SeasonGrandPrixResultsCreator(
            qualiStandingsBySeasonDriverIds:
                resultQualiStandingsBySeasonDriverIds,
          ).create(),
    );
    getDetailsOfAllDriversFromSeasonUseCase.mock(
      expectedDetailsOfAllDriversFromSeason: allDriverDetails,
    );
    seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
      seasonGrandPrixBetPoints: SeasonGrandPrixBetPoints(
        id: '',
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
        totalPoints: 0.0,
        qualiBetPoints: qualiBetPoints,
      ),
    );
    grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
      expectedStatus: BetStatus.loss,
    );
    when(
      () => grandPrixBetStatusService.selectStatusBasedOnPoints(
        any(that: anyOf(1, 2)),
      ),
    ).thenReturn(BetStatus.win);

    final Stream<List<SingleDriverBet>> bets$ = service.getQualiBets();

    expect(await bets$.first, expectedBets);
    verify(
      () => seasonGrandPrixBetRepository.getSeasonGrandPrixBet(
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    ).called(1);
    verify(
      () => seasonGrandPrixResultsRepository.getResultsForSeasonGrandPrix(
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    ).called(1);
    verify(
      () => getDetailsOfAllDriversFromSeasonUseCase.call(season),
    ).called(1);
    verify(
      () => seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    ).called(1);
  });
}
