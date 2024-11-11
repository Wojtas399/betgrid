import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_race_bets_service.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/race_bet_points_creator.dart';
import '../../../creator/season_driver_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';
import '../../../mock/data/repository/mock_season_driver_repository.dart';
import '../../../mock/ui/screen/grand_prix_bet/mock_grand_prix_bet_status_service.dart';
import '../../../mock/use_case/mock_get_driver_based_on_season_driver_use_case.dart';

void main() {
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();
  final seasonDriverRepository = MockSeasonDriverRepository();
  final getDriverBasedOnSeasonDriverUseCase =
      MockGetDriverBasedOnSeasonDriverUseCase();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  final grandPrixBetStatusService = MockGrandPrixBetStatusService();
  const String playerId = 'p1';
  const String seasonGrandPrixId = 'gp1';
  final service = GrandPrixBetRaceBetsService(
    grandPrixBetRepository,
    grandPrixResultsRepository,
    seasonDriverRepository,
    getDriverBasedOnSeasonDriverUseCase,
    grandPrixBetPointsRepository,
    grandPrixBetStatusService,
    playerId,
    seasonGrandPrixId,
  );

  tearDown(() {
    verify(
      () => grandPrixBetRepository.getGrandPrixBetForPlayerAndSeasonGrandPrix(
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    ).called(1);
    verify(
      () => grandPrixResultsRepository.getGrandPrixResultsForSeasonGrandPrix(
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    ).called(1);
    verify(
      () => grandPrixBetPointsRepository
          .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    ).called(1);
    reset(grandPrixBetRepository);
    reset(grandPrixResultsRepository);
    reset(seasonDriverRepository);
    reset(getDriverBasedOnSeasonDriverUseCase);
    reset(grandPrixBetPointsRepository);
    reset(grandPrixBetStatusService);
  });

  test(
    'getPodiumBets, '
    'should emit list of 3 SingleDriverBet elements with data corresponding '
    'to their positions',
    () async {
      final GrandPrixBet bet = GrandPrixBetCreator(
        p1SeasonDriverId: 'd1',
        p2SeasonDriverId: 'd2',
        p3SeasonDriverId: 'd3',
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        p1SeasonDriverId: 'd1',
        p2SeasonDriverId: 'd2',
        p3SeasonDriverId: 'd4',
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          p1Points: 2,
          p2Points: 2,
          p3Points: 0,
        ),
      ).createEntity();
      final List<SeasonDriver> seasonDrivers = [
        const SeasonDriverCreator(id: 'd1').createEntity(),
        const SeasonDriverCreator(id: 'd2').createEntity(),
        const SeasonDriverCreator(id: 'd3').createEntity(),
        const SeasonDriverCreator(id: 'd4').createEntity(),
      ];
      final List<Driver> drivers = [
        const DriverCreator(seasonDriverId: 'd1').create(),
        const DriverCreator(seasonDriverId: 'd2').create(),
        const DriverCreator(seasonDriverId: 'd3').create(),
        const DriverCreator(seasonDriverId: 'd4').create(),
      ];
      final List<SingleDriverBet> expectedBets = [
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: drivers.first,
          resultDriver: drivers.first,
          points: 2,
        ),
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: drivers[1],
          resultDriver: drivers[1],
          points: 2,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: drivers[2],
          resultDriver: drivers.last,
          points: 0,
        ),
      ];
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndSeasonGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForSeasonGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        grandPrixBetPoints: points,
      );
      when(
        () => seasonDriverRepository.getSeasonDriverById('d1'),
      ).thenAnswer((_) => Stream.value(seasonDrivers.first));
      when(
        () => seasonDriverRepository.getSeasonDriverById('d2'),
      ).thenAnswer((_) => Stream.value(seasonDrivers[1]));
      when(
        () => seasonDriverRepository.getSeasonDriverById('d3'),
      ).thenAnswer((_) => Stream.value(seasonDrivers[2]));
      when(
        () => seasonDriverRepository.getSeasonDriverById('d4'),
      ).thenAnswer((_) => Stream.value(seasonDrivers.last));
      when(
        () => getDriverBasedOnSeasonDriverUseCase(seasonDrivers.first),
      ).thenAnswer((_) => Stream.value(drivers.first));
      when(
        () => getDriverBasedOnSeasonDriverUseCase(seasonDrivers[1]),
      ).thenAnswer((_) => Stream.value(drivers[1]));
      when(
        () => getDriverBasedOnSeasonDriverUseCase(seasonDrivers[2]),
      ).thenAnswer((_) => Stream.value(drivers[2]));
      when(
        () => getDriverBasedOnSeasonDriverUseCase(seasonDrivers.last),
      ).thenAnswer((_) => Stream.value(drivers.last));
      grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
        expectedStatus: BetStatus.win,
      );
      when(
        () => grandPrixBetStatusService.selectStatusBasedOnPoints(0),
      ).thenReturn(BetStatus.loss);

      final Stream<List<SingleDriverBet>> podiumBets$ = service.getPodiumBets();

      expect(await podiumBets$.first, expectedBets);
    },
  );

  test(
    'getP10Bet, '
    'should emit SingleDriverBet element with p10 data',
    () async {
      final GrandPrixBet bet = GrandPrixBetCreator(
        p10SeasonDriverId: 'd10',
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        p10SeasonDriverId: 'd10',
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          p10Points: 2,
        ),
      ).createEntity();
      final SeasonDriver seasonDriver =
          const SeasonDriverCreator(id: 'd10').createEntity();
      final Driver driver = const DriverCreator(seasonDriverId: 'd10').create();
      const BetStatus betStatus = BetStatus.win;
      final SingleDriverBet expectedBet = SingleDriverBet(
        status: betStatus,
        betDriver: driver,
        resultDriver: driver,
        points: points.raceBetPoints?.p10Points,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndSeasonGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForSeasonGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        grandPrixBetPoints: points,
      );
      seasonDriverRepository.mockGetSeasonDriverById(
        expectedSeasonDriver: seasonDriver,
      );
      getDriverBasedOnSeasonDriverUseCase.mock(
        expectedDriver: driver,
      );
      grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
        expectedStatus: betStatus,
      );

      final Stream<SingleDriverBet> p10Bet$ = service.getP10Bet();

      expect(await p10Bet$.first, expectedBet);
    },
  );

  test(
    'getFastestLapBet, '
    'should emit SingleDriverBet element with fastest lap data',
    () async {
      final GrandPrixBet bet = GrandPrixBetCreator(
        fastestLapSeasonDriverId: 'd1',
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        fastestLapSeasonDriverId: 'd1',
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          fastestLapPoints: 2,
        ),
      ).createEntity();
      final SeasonDriver seasonDriver =
          const SeasonDriverCreator(id: 'd1').createEntity();
      final Driver driver = const DriverCreator(seasonDriverId: 'd1').create();
      const BetStatus betStatus = BetStatus.win;
      final SingleDriverBet expectedBet = SingleDriverBet(
        status: betStatus,
        betDriver: driver,
        resultDriver: driver,
        points: points.raceBetPoints?.fastestLapPoints,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndSeasonGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForSeasonGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        grandPrixBetPoints: points,
      );
      seasonDriverRepository.mockGetSeasonDriverById(
        expectedSeasonDriver: seasonDriver,
      );
      getDriverBasedOnSeasonDriverUseCase.mock(
        expectedDriver: driver,
      );
      grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
        expectedStatus: betStatus,
      );

      final Stream<SingleDriverBet> fastestLapBet$ = service.getFastestLapBet();

      expect(await fastestLapBet$.first, expectedBet);
    },
  );

  test(
    'getDnfDriversBet, '
    'should emit MultipleDriversBet element with dnf drivers data',
    () async {
      final GrandPrixBet bet = GrandPrixBetCreator(
        dnfSeasonDriverIds: ['d1', 'd2'],
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        dnfSeasonDriverIds: ['d1', 'd3', 'd5'],
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          dnfPoints: 2,
        ),
      ).createEntity();
      final List<SeasonDriver> seasonDrivers = [
        const SeasonDriverCreator(id: 'd1').createEntity(),
        const SeasonDriverCreator(id: 'd2').createEntity(),
        const SeasonDriverCreator(id: 'd3').createEntity(),
        const SeasonDriverCreator(id: 'd5').createEntity(),
      ];
      final List<Driver> drivers = [
        const DriverCreator(seasonDriverId: 'd1').create(),
        const DriverCreator(seasonDriverId: 'd2').create(),
        const DriverCreator(seasonDriverId: 'd3').create(),
        const DriverCreator(seasonDriverId: 'd5').create(),
      ];
      const BetStatus betStatus = BetStatus.win;
      final MultipleDriversBet expectedBet = MultipleDriversBet(
        status: betStatus,
        betDrivers: [drivers.first, drivers[1]],
        resultDrivers: [drivers.first, drivers[2], drivers.last],
        points: points.raceBetPoints?.dnfPoints,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndSeasonGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForSeasonGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        grandPrixBetPoints: points,
      );
      when(
        () => seasonDriverRepository.getSeasonDriverById('d1'),
      ).thenAnswer((_) => Stream.value(seasonDrivers.first));
      when(
        () => seasonDriverRepository.getSeasonDriverById('d2'),
      ).thenAnswer((_) => Stream.value(seasonDrivers[1]));
      when(
        () => seasonDriverRepository.getSeasonDriverById('d3'),
      ).thenAnswer((_) => Stream.value(seasonDrivers[2]));
      when(
        () => seasonDriverRepository.getSeasonDriverById('d5'),
      ).thenAnswer((_) => Stream.value(seasonDrivers.last));
      when(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers.first),
      ).thenAnswer((_) => Stream.value(drivers.first));
      when(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers[1]),
      ).thenAnswer((_) => Stream.value(drivers[1]));
      when(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers[2]),
      ).thenAnswer((_) => Stream.value(drivers[2]));
      when(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers.last),
      ).thenAnswer((_) => Stream.value(drivers.last));
      grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
        expectedStatus: betStatus,
      );

      final Stream<MultipleDriversBet> dnfDriversBet$ =
          service.getDnfDriversBet();

      expect(await dnfDriversBet$.first, expectedBet);
    },
  );

  test(
    'getSafetyCarBet, '
    'should emit BooleanBet element with safety car data',
    () async {
      final GrandPrixBet bet = GrandPrixBetCreator(
        willBeSafetyCar: false,
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        wasThereSafetyCar: true,
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          safetyCarPoints: 0,
        ),
      ).createEntity();
      const BetStatus betStatus = BetStatus.loss;
      final BooleanBet expectedBet = BooleanBet(
        status: betStatus,
        betValue: bet.willBeSafetyCar,
        resultValue: results.raceResults?.wasThereSafetyCar,
        points: points.raceBetPoints?.safetyCarPoints,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndSeasonGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForSeasonGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        grandPrixBetPoints: points,
      );
      grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
        expectedStatus: betStatus,
      );

      final Stream<BooleanBet> safetyCarBet$ = service.getSafetyCarBet();

      expect(await safetyCarBet$.first, expectedBet);
    },
  );

  test(
    'getRedFlagBet, '
    'should emit BooleanBet element with red flag data',
    () async {
      final GrandPrixBet bet = GrandPrixBetCreator(
        willBeRedFlag: true,
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        wasThereRedFlag: true,
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          redFlagPoints: 2,
        ),
      ).createEntity();
      const BetStatus betStatus = BetStatus.win;
      final BooleanBet expectedBet = BooleanBet(
        status: betStatus,
        betValue: bet.willBeRedFlag,
        resultValue: results.raceResults?.wasThereRedFlag,
        points: points.raceBetPoints?.redFlagPoints,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndSeasonGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForSeasonGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        grandPrixBetPoints: points,
      );
      grandPrixBetStatusService.mockSelectStatusBasedOnPoints(
        expectedStatus: betStatus,
      );

      final Stream<BooleanBet> redFlagBet$ = service.getRedFlagBet();

      expect(await redFlagBet$.first, expectedBet);
    },
  );
}
