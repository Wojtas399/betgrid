import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/model/season_grand_prix_bet.dart';
import 'package:betgrid/model/season_grand_prix_bet_points.dart';
import 'package:betgrid/model/season_grand_prix_results.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_cubit.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_race_bets_service.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_details_creator.dart';
import '../../../creator/season_grand_prix_bet_creator.dart';
import '../../../creator/season_grand_prix_bet_points_creator.dart';
import '../../../creator/season_grand_prix_results_creator.dart';
import '../../../creator/race_bet_points_creator.dart';
import '../../../creator/season_driver_creator.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_points_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_repository.dart';
import '../../../mock/repository/mock_season_grand_prix_results_repository.dart';
import '../../../mock/repository/mock_season_driver_repository.dart';
import '../../../mock/ui/screen/grand_prix_bet/mock_grand_prix_bet_status_service.dart';
import '../../../mock/use_case/mock_get_details_for_season_driver_use_case.dart';

void main() {
  final seasonGrandPrixBetRepository = MockSeasonGrandPrixBetRepository();
  final seasonGrandPrixResultsRepository =
      MockSeasonGrandPrixResultsRepository();
  final seasonDriverRepository = MockSeasonDriverRepository();
  final getDetailsForSeasonDriverUseCase =
      MockGetDetailsForSeasonDriverUseCase();
  final seasonGrandPrixBetPointsRepository =
      MockSeasonGrandPrixBetPointsRepository();
  final grandPrixBetStatusService = MockGrandPrixBetStatusService();
  const String playerId = 'p1';
  const int season = 2024;
  const String seasonGrandPrixId = 'gp1';
  final service = GrandPrixBetRaceBetsService(
    seasonGrandPrixBetRepository,
    seasonGrandPrixResultsRepository,
    seasonDriverRepository,
    getDetailsForSeasonDriverUseCase,
    seasonGrandPrixBetPointsRepository,
    grandPrixBetStatusService,
    const GrandPrixBetCubitParams(
      playerId: playerId,
      season: season,
      seasonGrandPrixId: seasonGrandPrixId,
    ),
  );

  tearDown(() {
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
      () => seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    ).called(1);
    reset(seasonGrandPrixBetRepository);
    reset(seasonGrandPrixResultsRepository);
    reset(seasonDriverRepository);
    reset(getDetailsForSeasonDriverUseCase);
    reset(seasonGrandPrixBetPointsRepository);
    reset(grandPrixBetStatusService);
  });

  test('getPodiumBets, '
      'should emit list of 3 SingleDriverBet elements with data corresponding '
      'to their positions', () async {
    final SeasonGrandPrixBet bet =
        SeasonGrandPrixBetCreator(
          p1SeasonDriverId: 'sd1',
          p2SeasonDriverId: 'sd2',
          p3SeasonDriverId: 'sd3',
        ).create();
    final SeasonGrandPrixResults results =
        const SeasonGrandPrixResultsCreator(
          p1SeasonDriverId: 'sd1',
          p2SeasonDriverId: 'sd2',
          p3SeasonDriverId: 'sd4',
        ).create();
    final SeasonGrandPrixBetPoints points =
        const SeasonGrandPrixBetPointsCreator(
          raceBetPointsCreator: RaceBetPointsCreator(p1: 2, p2: 2, p3: 0),
        ).create();
    final List<SeasonDriver> seasonDrivers = [
      const SeasonDriverCreator(id: 'sd1').create(),
      const SeasonDriverCreator(id: 'sd2').create(),
      const SeasonDriverCreator(id: 'sd3').create(),
      const SeasonDriverCreator(id: 'sd4').create(),
    ];
    final List<DriverDetails> driversDetails = [
      const DriverDetailsCreator(seasonDriverId: 'sd1').create(),
      const DriverDetailsCreator(seasonDriverId: 'sd2').create(),
      const DriverDetailsCreator(seasonDriverId: 'sd3').create(),
      const DriverDetailsCreator(seasonDriverId: 'sd4').create(),
    ];
    final List<SingleDriverBet> expectedBets = [
      SingleDriverBet(
        status: BetStatus.win,
        betDriver: driversDetails.first,
        resultDriver: driversDetails.first,
        points: 2,
      ),
      SingleDriverBet(
        status: BetStatus.win,
        betDriver: driversDetails[1],
        resultDriver: driversDetails[1],
        points: 2,
      ),
      SingleDriverBet(
        status: BetStatus.loss,
        betDriver: driversDetails[2],
        resultDriver: driversDetails.last,
        points: 0,
      ),
    ];
    seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet(
      seasonGrandPrixBet: bet,
    );
    seasonGrandPrixResultsRepository.mockGetResultsForSeasonGrandPrix(
      results: results,
    );
    seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
      seasonGrandPrixBetPoints: points,
    );
    for (int i = 0; i < 4; i++) {
      when(
        () => seasonDriverRepository.getById(
          season: season,
          seasonDriverId: seasonDrivers[i].id,
        ),
      ).thenAnswer((_) => Stream.value(seasonDrivers[i]));
      when(
        () => getDetailsForSeasonDriverUseCase(seasonDrivers[i]),
      ).thenAnswer((_) => Stream.value(driversDetails[i]));
    }
    grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
      expectedStatus: BetStatus.win,
    );
    when(
      () => grandPrixBetStatusService.selectStatusBasedOnPoints(0),
    ).thenReturn(BetStatus.loss);

    final Stream<List<SingleDriverBet>> podiumBets$ = service.getPodiumBets();

    expect(await podiumBets$.first, expectedBets);
  });

  test('getP10Bet, '
      'should emit SingleDriverBet element with p10 data', () async {
    final SeasonGrandPrixBet bet =
        SeasonGrandPrixBetCreator(p10SeasonDriverId: 'sd10').create();
    final SeasonGrandPrixResults results =
        const SeasonGrandPrixResultsCreator(p10SeasonDriverId: 'sd10').create();
    final SeasonGrandPrixBetPoints points =
        const SeasonGrandPrixBetPointsCreator(
          raceBetPointsCreator: RaceBetPointsCreator(p10: 2),
        ).create();
    final SeasonDriver seasonDriver =
        const SeasonDriverCreator(id: 'sd10').create();
    final DriverDetails driver =
        const DriverDetailsCreator(seasonDriverId: 'sd10').create();
    const BetStatus betStatus = BetStatus.win;
    final SingleDriverBet expectedBet = SingleDriverBet(
      status: betStatus,
      betDriver: driver,
      resultDriver: driver,
      points: points.raceBetPoints?.p10,
    );
    seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet(
      seasonGrandPrixBet: bet,
    );
    seasonGrandPrixResultsRepository.mockGetResultsForSeasonGrandPrix(
      results: results,
    );
    seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
      seasonGrandPrixBetPoints: points,
    );
    seasonDriverRepository.mockGetById(expectedSeasonDriver: seasonDriver);
    getDetailsForSeasonDriverUseCase.mock(expectedDriverDetails: driver);
    grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
      expectedStatus: betStatus,
    );

    final Stream<SingleDriverBet> p10Bet$ = service.getP10Bet();

    expect(await p10Bet$.first, expectedBet);
  });

  test('getFastestLapBet, '
      'should emit SingleDriverBet element with fastest lap data', () async {
    final SeasonGrandPrixBet bet =
        SeasonGrandPrixBetCreator(fastestLapSeasonDriverId: 'sd1').create();
    final SeasonGrandPrixResults results =
        const SeasonGrandPrixResultsCreator(
          fastestLapSeasonDriverId: 'sd1',
        ).create();
    final SeasonGrandPrixBetPoints points =
        const SeasonGrandPrixBetPointsCreator(
          raceBetPointsCreator: RaceBetPointsCreator(fastestLap: 2),
        ).create();
    final SeasonDriver seasonDriver =
        const SeasonDriverCreator(id: 'sd1').create();
    final DriverDetails driver =
        const DriverDetailsCreator(seasonDriverId: 'sd1').create();
    const BetStatus betStatus = BetStatus.win;
    final SingleDriverBet expectedBet = SingleDriverBet(
      status: betStatus,
      betDriver: driver,
      resultDriver: driver,
      points: points.raceBetPoints?.fastestLap,
    );
    seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet(
      seasonGrandPrixBet: bet,
    );
    seasonGrandPrixResultsRepository.mockGetResultsForSeasonGrandPrix(
      results: results,
    );
    seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
      seasonGrandPrixBetPoints: points,
    );
    seasonDriverRepository.mockGetById(expectedSeasonDriver: seasonDriver);
    getDetailsForSeasonDriverUseCase.mock(expectedDriverDetails: driver);
    grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
      expectedStatus: betStatus,
    );

    final Stream<SingleDriverBet> fastestLapBet$ = service.getFastestLapBet();

    expect(await fastestLapBet$.first, expectedBet);
  });

  test('getDnfDriversBet, '
      'should emit MultipleDriversBet element with dnf drivers data', () async {
    final SeasonGrandPrixBet bet =
        SeasonGrandPrixBetCreator(dnfSeasonDriverIds: ['sd1', 'sd2']).create();
    final SeasonGrandPrixResults results =
        const SeasonGrandPrixResultsCreator(
          dnfSeasonDriverIds: ['sd1', 'sd3', 'sd5'],
        ).create();
    final SeasonGrandPrixBetPoints points =
        const SeasonGrandPrixBetPointsCreator(
          raceBetPointsCreator: RaceBetPointsCreator(totalDnf: 2),
        ).create();
    final List<SeasonDriver> seasonDrivers = [
      const SeasonDriverCreator(id: 'sd1').create(),
      const SeasonDriverCreator(id: 'sd2').create(),
      const SeasonDriverCreator(id: 'sd3').create(),
      const SeasonDriverCreator(id: 'sd5').create(),
    ];
    final List<DriverDetails> drivers = [
      const DriverDetailsCreator(seasonDriverId: 'sd1').create(),
      const DriverDetailsCreator(seasonDriverId: 'sd2').create(),
      const DriverDetailsCreator(seasonDriverId: 'sd3').create(),
      const DriverDetailsCreator(seasonDriverId: 'sd5').create(),
    ];
    const BetStatus betStatus = BetStatus.win;
    final MultipleDriversBet expectedBet = MultipleDriversBet(
      status: betStatus,
      betDrivers: [drivers.first, drivers[1]],
      resultDrivers: [drivers.first, drivers[2], drivers.last],
      points: points.raceBetPoints?.totalDnf,
    );
    seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet(
      seasonGrandPrixBet: bet,
    );
    seasonGrandPrixResultsRepository.mockGetResultsForSeasonGrandPrix(
      results: results,
    );
    seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
      seasonGrandPrixBetPoints: points,
    );
    for (int i = 0; i < 4; i++) {
      when(
        () => seasonDriverRepository.getById(
          season: season,
          seasonDriverId: seasonDrivers[i].id,
        ),
      ).thenAnswer((_) => Stream.value(seasonDrivers[i]));
      when(
        () => getDetailsForSeasonDriverUseCase(seasonDrivers[i]),
      ).thenAnswer((_) => Stream.value(drivers[i]));
    }
    grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
      expectedStatus: betStatus,
    );

    final Stream<MultipleDriversBet> dnfDriversBet$ =
        service.getDnfDriversBet();

    expect(await dnfDriversBet$.first, expectedBet);
  });

  test('getSafetyCarBet, '
      'should emit BooleanBet element with safety car data', () async {
    final SeasonGrandPrixBet bet =
        SeasonGrandPrixBetCreator(willBeSafetyCar: false).create();
    final SeasonGrandPrixResults results =
        const SeasonGrandPrixResultsCreator(wasThereSafetyCar: true).create();
    final SeasonGrandPrixBetPoints points =
        const SeasonGrandPrixBetPointsCreator(
          raceBetPointsCreator: RaceBetPointsCreator(safetyCar: 0),
        ).create();
    const BetStatus betStatus = BetStatus.loss;
    final BooleanBet expectedBet = BooleanBet(
      status: betStatus,
      betValue: bet.willBeSafetyCar,
      resultValue: results.raceResults?.wasThereSafetyCar,
      points: points.raceBetPoints?.safetyCar,
    );
    seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet(
      seasonGrandPrixBet: bet,
    );
    seasonGrandPrixResultsRepository.mockGetResultsForSeasonGrandPrix(
      results: results,
    );
    seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
      seasonGrandPrixBetPoints: points,
    );
    grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
      expectedStatus: betStatus,
    );

    final Stream<BooleanBet> safetyCarBet$ = service.getSafetyCarBet();

    expect(await safetyCarBet$.first, expectedBet);
  });

  test('getRedFlagBet, '
      'should emit BooleanBet element with red flag data', () async {
    final SeasonGrandPrixBet bet =
        SeasonGrandPrixBetCreator(willBeRedFlag: true).create();
    final SeasonGrandPrixResults results =
        const SeasonGrandPrixResultsCreator(wasThereRedFlag: true).create();
    final SeasonGrandPrixBetPoints points =
        const SeasonGrandPrixBetPointsCreator(
          raceBetPointsCreator: RaceBetPointsCreator(redFlag: 2),
        ).create();
    const BetStatus betStatus = BetStatus.win;
    final BooleanBet expectedBet = BooleanBet(
      status: betStatus,
      betValue: bet.willBeRedFlag,
      resultValue: results.raceResults?.wasThereRedFlag,
      points: points.raceBetPoints?.redFlag,
    );
    seasonGrandPrixBetRepository.mockGetSeasonGrandPrixBet(
      seasonGrandPrixBet: bet,
    );
    seasonGrandPrixResultsRepository.mockGetResultsForSeasonGrandPrix(
      results: results,
    );
    seasonGrandPrixBetPointsRepository.mockGetSeasonGetGrandPrixBetPoints(
      seasonGrandPrixBetPoints: points,
    );
    grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
      expectedStatus: betStatus,
    );

    final Stream<BooleanBet> redFlagBet$ = service.getRedFlagBet();

    expect(await redFlagBet$.first, expectedBet);
  });
}
