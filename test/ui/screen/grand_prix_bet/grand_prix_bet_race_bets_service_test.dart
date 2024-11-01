import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_race_bets_service.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/race_bet_points_creator.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';
import '../../../mock/ui/screen/grand_prix_bet/mock_grand_prix_bet_status_service.dart';

void main() {
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();
  final driverRepository = MockDriverRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  final grandPrixBetStatusService = MockGrandPrixBetStatusService();
  const String playerId = 'p1';
  const String grandPrixId = 'gp1';
  final service = GrandPrixBetRaceBetsService(
    grandPrixBetRepository,
    grandPrixResultsRepository,
    driverRepository,
    grandPrixBetPointsRepository,
    grandPrixBetStatusService,
    playerId,
    grandPrixId,
  );

  test(
    'getPodiumBets, '
    'should emit list of 3 SingleDriverBet elements with data corresponding '
    'to their positions',
    () async {
      final GrandPrixBet bet = GrandPrixBetCreator(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd4',
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          p1Points: 2,
          p2Points: 2,
          p3Points: 0,
        ),
      ).createEntity();
      final List<Driver> allDrivers = [
        const DriverCreator(id: 'd1').createEntity(),
        const DriverCreator(id: 'd2').createEntity(),
        const DriverCreator(id: 'd3').createEntity(),
        const DriverCreator(id: 'd4').createEntity(),
      ];
      final List<SingleDriverBet> expectedBets = [
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: allDrivers.first,
          resultDriver: allDrivers.first,
          points: 2,
        ),
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: allDrivers[1],
          resultDriver: allDrivers[1],
          points: 2,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: allDrivers[2],
          resultDriver: allDrivers.last,
          points: 0,
        ),
      ];
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        grandPrixBetPoints: points,
      );
      driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
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
        p10DriverId: 'd10',
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        p10DriverId: 'd10',
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          p10Points: 2,
        ),
      ).createEntity();
      final List<Driver> allDrivers = [
        const DriverCreator(id: 'd1').createEntity(),
        const DriverCreator(id: 'd10').createEntity(),
      ];
      const BetStatus betStatus = BetStatus.win;
      final SingleDriverBet expectedBet = SingleDriverBet(
        status: betStatus,
        betDriver: allDrivers.last,
        resultDriver: allDrivers.last,
        points: points.raceBetPoints?.p10Points,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        grandPrixBetPoints: points,
      );
      driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
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
        fastestLapDriverId: 'd1',
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        fastestLapDriverId: 'd1',
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          fastestLapPoints: 2,
        ),
      ).createEntity();
      final List<Driver> allDrivers = [
        const DriverCreator(id: 'd1').createEntity(),
        const DriverCreator(id: 'd10').createEntity(),
      ];
      const BetStatus betStatus = BetStatus.win;
      final SingleDriverBet expectedBet = SingleDriverBet(
        status: betStatus,
        betDriver: allDrivers.first,
        resultDriver: allDrivers.first,
        points: points.raceBetPoints?.fastestLapPoints,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        grandPrixBetPoints: points,
      );
      driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
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
        dnfDriverIds: ['d1', 'd2'],
      ).createEntity();
      final GrandPrixResults results = const GrandPrixResultsCreator(
        dnfDriverIds: ['d1', 'd3', 'd5'],
      ).createEntity();
      final GrandPrixBetPoints points = const GrandPrixBetPointsCreator(
        raceBetPointsCreator: RaceBetPointsCreator(
          dnfPoints: 2,
        ),
      ).createEntity();
      final List<Driver> allDrivers = [
        const DriverCreator(id: 'd1').createEntity(),
        const DriverCreator(id: 'd2').createEntity(),
        const DriverCreator(id: 'd3').createEntity(),
        const DriverCreator(id: 'd5').createEntity(),
      ];
      const BetStatus betStatus = BetStatus.win;
      final MultipleDriversBet expectedBet = MultipleDriversBet(
        status: betStatus,
        betDrivers: [allDrivers.first, allDrivers[1]],
        resultDrivers: [allDrivers.first, allDrivers[2], allDrivers.last],
        points: points.raceBetPoints?.dnfPoints,
      );
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        grandPrixBetPoints: points,
      );
      driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
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
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
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
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: bet,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
        results: results,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
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
