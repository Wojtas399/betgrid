import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_quali_bets_service.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/quali_bet_points_creator.dart';
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
  final service = GrandPrixBetQualiBetsService(
    grandPrixBetRepository,
    grandPrixResultsRepository,
    driverRepository,
    grandPrixBetPointsRepository,
    grandPrixBetStatusService,
  );

  test(
    'should create list with 20 SingleDriverBet elements where each element '
    'has data corresponding to its position',
    () async {
      const String playerId = 'p1';
      const String grandPrixId = 'gp1';
      final List<Driver> allDrivers = List.generate(
        20,
        (int driverIndex) => DriverCreator(
          id: 'd${driverIndex + 1}',
        ).createEntity(),
      );
      final List<String?> betQualiStandingsByDriverIds = List.generate(
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
      final List<String> resultQualiStandingsByDriverIds = [
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
      final QualiBetPoints qualiBetPoints = const QualiBetPointsCreator(
        q3P1Points: 1,
        q3P2Points: 0,
        q3P3Points: 0,
        q3P4Points: 0,
        q3P5Points: 2,
        q3P6Points: 2,
        q3P7Points: 0,
        q3P8Points: 0,
        q3P9Points: 0,
        q3P10Points: 0,
        q2P11Points: 0,
        q2P12Points: 0,
        q2P13Points: 2,
        q2P14Points: 0,
        q2P15Points: 0,
        q1P16Points: 0,
        q1P17Points: 0,
        q1P18Points: 0,
        q1P19Points: 0,
        q1P20Points: 0,
      ).createEntity();
      final List<SingleDriverBet> expectedBets = [
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: allDrivers.first,
          resultDriver: allDrivers.first,
          points: 1,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[2],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[3],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[18],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: allDrivers[4],
          resultDriver: allDrivers[4],
          points: 2,
        ),
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: allDrivers[5],
          resultDriver: allDrivers[5],
          points: 2,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[6],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[7],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[8],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: allDrivers[8],
          resultDriver: allDrivers[1],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[9],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[10],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.win,
          betDriver: allDrivers[12],
          resultDriver: allDrivers[12],
          points: 2,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[11],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[14],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[13],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[17],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: allDrivers[17],
          resultDriver: allDrivers[15],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: null,
          resultDriver: allDrivers[16],
          points: 0,
        ),
        SingleDriverBet(
          status: BetStatus.loss,
          betDriver: allDrivers[7],
          resultDriver: allDrivers[19],
          points: 0,
        ),
      ];
      grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
        grandPrixBet: GrandPrixBetCreator(
          qualiStandingsByDriverIds: betQualiStandingsByDriverIds,
        ).createEntity(),
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
          results: GrandPrixResultsCreator(
        qualiStandingsByDriverIds: resultQualiStandingsByDriverIds,
      ).createEntity());
      driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
        grandPrixBetPoints: GrandPrixBetPoints(
          id: '',
          playerId: playerId,
          grandPrixId: grandPrixId,
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

      final Stream<List<SingleDriverBet>> bets$ = service.getQualiBets(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );

      expect(await bets$.first, expectedBets);
    },
  );
}
