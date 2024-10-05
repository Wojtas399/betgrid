import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_points_for_driver_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../creator/quali_bet_points_creator.dart';
import '../../../creator/race_bet_points_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/use_case/mock_get_finished_grand_prixes_from_current_season_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getFinishedGrandPrixesFromCurrentSeasonUseCase =
      MockGetFinishedGrandPrixesFromCurrentSeasonUseCase();
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  late CreatePointsForDriverStats createPointsForDriverStats;

  setUp(() {
    createPointsForDriverStats = CreatePointsForDriverStats(
      playerRepository,
      getFinishedGrandPrixesFromCurrentSeasonUseCase,
      grandPrixResultsRepository,
      grandPrixBetPointsRepository,
      grandPrixBetRepository,
    );
  });

  tearDown(() {
    reset(playerRepository);
    reset(getFinishedGrandPrixesFromCurrentSeasonUseCase);
    reset(grandPrixResultsRepository);
    reset(grandPrixBetPointsRepository);
    reset(grandPrixBetRepository);
  });

  test(
    'should emit null if list of all players is empty',
    () async {
      playerRepository.mockGetAllPlayers(players: []);
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: [
          GrandPrixCreator(id: 'gp1').createEntity(),
          GrandPrixCreator(id: 'gp2').createEntity(),
        ],
      );

      final Stream<List<PointsByDriverPlayerPoints>?> pointsForDriver$ =
          createPointsForDriverStats(
        driverId: 'd1',
      );

      expect(await pointsForDriver$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
    },
  );

  test(
    'should return null if list of ids of finished grand prixes is empty',
    () async {
      playerRepository.mockGetAllPlayers(
        players: [
          PlayerCreator(id: 'p1').createEntity(),
          PlayerCreator(id: 'p2').createEntity(),
        ],
      );
      getFinishedGrandPrixesFromCurrentSeasonUseCase
          .mock(finishedGrandPrixes: []);

      final Stream<List<PointsByDriverPlayerPoints>?> pointsForDriver$ =
          createPointsForDriverStats(
        driverId: 'd1',
      );

      expect(await pointsForDriver$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
    },
  );

  test(
    'for each player should sum points received for driver in every grand prix',
    () async {
      const String driverId = 'd1';
      final List<Player> players = [
        PlayerCreator(id: 'p1').createEntity(),
        PlayerCreator(id: 'p2').createEntity(),
        PlayerCreator(id: 'p3').createEntity(),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        GrandPrixCreator(id: 'gp1').createEntity(),
        GrandPrixCreator(id: 'gp2').createEntity(),
        GrandPrixCreator(id: 'gp3').createEntity(),
      ];
      final List<String> playersIds =
          players.map((player) => player.id).toList();
      final List<String> finishedGrandPrixesIds =
          finishedGrandPrixes.map((gp) => gp.id).toList();
      final List<GrandPrixResults> grandPrixesResults = [
        GrandPrixResultsCreator(
          grandPrixId: finishedGrandPrixes.first.id,
          qualiStandingsByDriverIds: [
            driverId,
            'd2',
            'd3',
            'd4',
            'd5',
            'd6',
            'd7',
            'd8',
            'd9',
            'd10',
            'd11',
            'd12',
            'd13',
            'd14',
            'd15',
            'd16',
            'd17',
            'd18',
            'd19',
            'd20',
          ],
          p1DriverId: driverId,
          p2DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: driverId,
          dnfDriverIds: ['d18', 'd19', 'd20'],
        ).createEntity(),
        GrandPrixResultsCreator(
          grandPrixId: finishedGrandPrixes[1].id,
          qualiStandingsByDriverIds: [
            'd20',
            'd19',
            'd18',
            'd17',
            'd16',
            'd15',
            'd14',
            'd13',
            'd12',
            'd11',
            'd10',
            driverId,
            'd8',
            'd7',
            'd6',
            'd5',
            'd4',
            'd3',
            'd2',
            'd9',
          ],
          p1DriverId: 'd20',
          p2DriverId: 'd19',
          p3DriverId: 'd18',
          p10DriverId: 'd11',
          fastestLapDriverId: 'd20',
          dnfDriverIds: [driverId, 'd2'],
        ).createEntity(),
        GrandPrixResultsCreator(
          grandPrixId: finishedGrandPrixes.last.id,
          qualiStandingsByDriverIds: [
            'd20',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
            driverId,
          ],
          p1DriverId: 'd3',
          p2DriverId: 'd2',
          p3DriverId: driverId,
          p10DriverId: 'd4',
          fastestLapDriverId: 'd3',
          dnfDriverIds: [driverId],
        ).createEntity(),
      ];
      final List<GrandPrixBetPoints> grandPrixesBetPoints = [
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          grandPrixId: finishedGrandPrixes.first.id,
          qualiBetPointsCreator: QualiBetPointsCreator(q3P1Points: 1),
          raceBetPointsCreator: RaceBetPointsCreator(
            p1Points: 2,
            fastestLapPoints: 2,
          ),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          grandPrixId: finishedGrandPrixes[1].id,
          qualiBetPointsCreator: QualiBetPointsCreator(q1P20Points: 1),
          raceBetPointsCreator: RaceBetPointsCreator(dnfDriver1Points: 2),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          grandPrixId: finishedGrandPrixes.last.id,
          qualiBetPointsCreator: QualiBetPointsCreator(q3P1Points: 1),
          raceBetPointsCreator: RaceBetPointsCreator(p3Points: 2),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          grandPrixId: finishedGrandPrixes.first.id,
          qualiBetPointsCreator: QualiBetPointsCreator(q3P4Points: 2),
          raceBetPointsCreator: RaceBetPointsCreator(
            p2Points: 2,
            p10Points: 2,
            fastestLapPoints: 2,
          ),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          grandPrixId: finishedGrandPrixes[1].id,
          qualiBetPointsCreator: QualiBetPointsCreator(q2P12Points: 2),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          grandPrixId: finishedGrandPrixes.last.id,
          qualiBetPointsCreator: QualiBetPointsCreator(q3P1Points: 1),
          raceBetPointsCreator: RaceBetPointsCreator(p3Points: 2),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          grandPrixId: finishedGrandPrixes.first.id,
          qualiBetPointsCreator: QualiBetPointsCreator(q3P10Points: 1),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          grandPrixId: finishedGrandPrixes[1].id,
          qualiBetPointsCreator: QualiBetPointsCreator(q1P18Points: 1),
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          grandPrixId: finishedGrandPrixes.last.id,
          qualiBetPointsCreator: QualiBetPointsCreator(q3P5Points: 2),
          raceBetPointsCreator: RaceBetPointsCreator(
            p2Points: 2,
            dnfDriver1Points: 2,
          ),
        ).createEntity(),
      ];
      final List<GrandPrixBet> grandPrixBets = [
        GrandPrixBetCreator(
          playerId: players.first.id,
          grandPrixId: finishedGrandPrixes.first.id,
          dnfDriverIds: [driverId, 'd2', 'd3'],
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players.first.id,
          grandPrixId: finishedGrandPrixes[1].id,
          dnfDriverIds: [driverId, null, null],
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players.first.id,
          grandPrixId: finishedGrandPrixes.last.id,
          dnfDriverIds: [driverId, 'd2', null],
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players[1].id,
          grandPrixId: finishedGrandPrixes.first.id,
          dnfDriverIds: [driverId, 'd2', 'd20'],
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players[1].id,
          grandPrixId: finishedGrandPrixes[1].id,
          dnfDriverIds: [null, null, null],
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players[1].id,
          grandPrixId: finishedGrandPrixes.last.id,
          dnfDriverIds: ['d14', 'd15', null],
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players.last.id,
          grandPrixId: finishedGrandPrixes.first.id,
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players.last.id,
          grandPrixId: finishedGrandPrixes[1].id,
        ).createEntity(),
        GrandPrixBetCreator(
          playerId: players.last.id,
          grandPrixId: finishedGrandPrixes.last.id,
          dnfDriverIds: [driverId, 'd15', 'd18'],
        ).createEntity(),
      ];
      final expectedPointsForDriver = [
        PointsByDriverPlayerPoints(
          player: players.first,
          points: 9,
        ),
        PointsByDriverPlayerPoints(
          player: players[1],
          points: 6,
        ),
        PointsByDriverPlayerPoints(
          player: players.last,
          points: 2,
        ),
      ];
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrixes(
        grandPrixesResults: grandPrixesResults,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );
      grandPrixBetRepository.mockGetGrandPrixBetsForPlayersAndGrandPrixes(
        grandPrixBets: grandPrixBets,
      );

      final Stream<List<PointsByDriverPlayerPoints>?> pointsForDriver$ =
          createPointsForDriverStats(
        driverId: 'd1',
      );

      expect(await pointsForDriver$.first, expectedPointsForDriver);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
      verify(
        () => grandPrixResultsRepository.getGrandPrixResultsForGrandPrixes(
          idsOfGrandPrixes: finishedGrandPrixesIds,
        ),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: playersIds,
          idsOfGrandPrixes: finishedGrandPrixesIds,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetsForPlayersAndGrandPrixes(
          idsOfPlayers: playersIds,
          idsOfGrandPrixes: finishedGrandPrixesIds,
        ),
      ).called(1);
    },
  );
}
